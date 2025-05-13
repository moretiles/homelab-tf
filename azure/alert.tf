resource "azurerm_monitor_action_group" "homelab" {
    name = "homelab_monitor"
    short_name = "homelab"
    resource_group_name = azurerm_resource_group.homelab.name
}

resource "azurerm_consumption_budget_resource_group" "homelab" {
    name = "homelab_budget"
    resource_group_id = azurerm_resource_group.homelab.id

    amount = 20
    time_grain = "Monthly"

    time_period {
        start_date = "2025-05-01T00:00:00Z"
        end_date = "2125-05-01T00:00:00Z"
    }

    notification {
        enabled = true
        threshold = 50.0
        operator = "GreaterThan"
        threshold_type = "Actual"

        contact_emails = [
            var.my_email,
        ]

        contact_groups = [
            azurerm_monitor_action_group.homelab.id,
        ]
    }
}
