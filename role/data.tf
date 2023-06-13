locals {
  assume_role_policy = jsondecode(var.assume_role_policy)
  inline_policies    = { for name, policy in var.inline_policies : name => jsondecode(policy) }
}

data "aws_iam_policy" "managed_policies" {
  for_each = var.policies

  name = each.value
}

data "aws_iam_policy" "permissions_boundary" {
  count = var.permissions_boundary != null ? 1 : 0

  name = var.permissions_boundary
}

data "aws_iam_policy_document" "assume_role_policy" {
  version = local.assume_role_policy["Version"]

  dynamic "statement" {
    for_each = flatten([local.assume_role_policy["Statement"]])

    content {
      sid = lookup(statement.value, "Sid", null)

      effect = statement.value["Effect"]

      actions     = try(tolist(statement.value["Action"]), [statement.value["Action"]], null)
      not_actions = try(tolist(statement.value["NotAction"]), [statement.value["NotAction"]], null)

      dynamic "principals" {
        for_each = lookup(statement.value, "Principal", {})

        content {
          type        = principals.key
          identifiers = try(tolist(principals.value), [principals.value])
        }
      }

      dynamic "not_principals" {
        for_each = lookup(statement.value, "NotPrincipal", {})

        content {
          type        = not_principals.key
          identifiers = try(tolist(not_principals.value), [not_principals.value])
        }
      }

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
      condition     = alltrue([for statement in flatten([local.assume_role_policy["Statement"]]) : ((can(statement["Action"]) || can(statement["NotAction"])) && !(can(statement["Action"]) && can(statement["NotAction"])))])
      error_message = "${var.name} assume role policy must contain either Action or NotAction"
    }

    precondition {
      condition     = alltrue([for statement in flatten([local.assume_role_policy["Statement"]]) : ((can(statement["Principal"]) || (can(statement["NotPrincipal"]) && statement["Effect"] != "Allow")) && !(can(statement["Principal"]) && can(statement["NotPrincipal"])))])
      error_message = "${var.name} assume role policy must contain either Principal or NotPrincipal with Deny"
    }
  }
}

data "aws_iam_policy_document" "inline_policy" {
  for_each = local.inline_policies

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
