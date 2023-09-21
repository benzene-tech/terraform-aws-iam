locals {
  inline_policy = jsondecode(var.inline_policy)
}

data "aws_iam_policy" "this" {
  for_each = toset(compact(concat(tolist(var.customer_managed_policies), (var.permissions_boundary.managed_by == "Customer" ? [var.permissions_boundary.name] : []))))

  name = each.value
}

data "aws_iam_policy_document" "this" {
  count = local.inline_policy != null ? 1 : 0

  version = local.inline_policy["Version"]

  dynamic "statement" {
    for_each = flatten([local.inline_policy["Statement"]])

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
      condition     = alltrue([for statement in flatten([local.inline_policy["Statement"]]) : ((can(statement["Action"]) || can(statement["NotAction"])) && !(can(statement["Action"]) && can(statement["NotAction"])))])
      error_message = "${var.name} inline policy statement must contain either Action or NotAction"
    }

    precondition {
      condition     = alltrue([for statement in flatten([local.inline_policy["Statement"]]) : ((can(statement["Resource"]) || can(statement["NotResource"])) && !(can(statement["Resource"]) && can(statement["NotResource"])))])
      error_message = "${var.name} inline policy statement must contain either Resource or NotResource"
    }
  }
}
