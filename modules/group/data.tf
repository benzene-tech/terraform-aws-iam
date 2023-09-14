locals {
  policy_documents = { for name, policy in var.policy_documents : name => jsondecode(policy) }
}

data "aws_iam_policy" "this" {
  for_each = var.name != null ? var.policies : []

  name = each.value
}

data "aws_iam_policy_document" "this" {
  for_each = var.name != null ? local.policy_documents : {}

  version = each.value["Version"]

  dynamic "statement" {
    for_each = flatten([each.value["Statement"]])

    content {
      sid = lookup(statement.value, "Sid", null)

      effect = statement.value["Effect"]

      actions     = try(tolist(statement.value["Action"]), [statement.value["Action"]], null)
      not_actions = try(tolist(statement.value["NotAction"]), [statement.value["NotAction"]], null)

      resources     = try(tolist(statement.value["Resource"]), [statement.value["Resource"]], null)
      not_resources = try(tolist(statement.value["NotResource"]), [statement.value["NotResource"]], null)

      dynamic "condition" {
        for_each = distinct(flatten([
          for test, variables in lookup(statement.value, "Condition", {}) : [
            for variable, values in variables : {
              test     = test
              variable = variable
              values   = try(tolist(values), [values])
            }
          ]
        ]))

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }

  lifecycle {
    precondition {
      condition     = alltrue([for statement in flatten([each.value["Statement"]]) : ((can(statement["Action"]) || can(statement["NotAction"])) && !(can(statement["Action"]) && can(statement["NotAction"])))])
      error_message = "${each.key} inline policy in ${var.name} policy must contain either Action or NotAction"
    }

    precondition {
      condition     = alltrue([for statement in flatten([each.value["Statement"]]) : ((can(statement["Resource"]) || can(statement["NotResource"])) && !(can(statement["Resource"]) && can(statement["NotResource"])))])
      error_message = "${each.key} inline policy in ${var.name} policy must contain either Resource or NotResource"
    }
  }
}
