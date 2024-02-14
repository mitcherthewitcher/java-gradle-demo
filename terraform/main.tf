data "datadog_role" "admin_role" {
  filter = "Datadog Admin Role"
}
data "datadog_user" "mitch" {
  filter = "mitch@rapdev.io"
}

resource "datadog_team" "mitch-terraform" {
  description = <<EOT
    # Mitch Terraform On-Call Team

Welcome to the Mitch Terraform on-call team documentation. This team is responsible for maintaining and troubleshooting our Terraform infrastructure. Below you'll find the contact information for all current on-call team members, along with our escalation procedures and schedules.

## Team Members

| Name            | Role                | Email                     | Phone       |
|-----------------|---------------------|---------------------------|-------------|
| John Doe        | Infrastructure Lead | john.doe@example.com      | 123-456-7890|
| Jane Smith      | DevOps Engineer     | jane.smith@example.com    | 098-765-4321|
| [Add more members as needed]

## Escalation Procedure

1. **Initial Contact**: Reach out to the primary on-call engineer via Slack or email.
2. **Urgent Issues**: If there is no response within 15 minutes, escalate to the next person on the call list.
3. **Major Incidents**: For issues affecting production, escalate directly to the Infrastructure Lead.
4. **External Support**: If the issue cannot be resolved internally, escalate to our external support provider [Provider Name] by emailing [Support Email] or calling [Support Phone].

## On-Call Schedule

Please refer to our internal scheduling tool at [Scheduling Tool Link] for the current on-call rotation and to sign up for shifts.

## Useful Links

- Terraform Documentation: [https://www.terraform.io/docs](https://www.terraform.io/docs)
- Internal Wiki: [Link to internal wiki]
- Incident Management Tool: [Link to tool]

Remember, effective communication and prompt attention to incidents are key to our success as an on-call team. Thank you for your dedication and hard work.

  EOT
  handle      = "mitch-terraform"
  name        = "Mitch Terraform"
}

resource "datadog_team_membership" "mitch-terraform-membership" {
  team_id = datadog_team.mitch-terraform.id
  user_id = data.datadog_user.mitch.id
  role    = "admin"
}

resource "datadog_monitor" "mitch-terraform-monitor" {
  name               = "mitch terraform test monitor"
  type               = "metric alert"
  message            = "Monitor triggered. Notify @mitch@rapdev.io"
  escalation_message = "Escalation message @mitch@rapdev.io"

  query = "avg(last_1h):(1 - avg:system.cpu.idle{env:mitch-macbook} by {host}) > 0.9"

  monitor_thresholds {
    warning  = 0.8
    critical = 0.9
  }

  include_tags = false

  tags = ["foo:bar", "team:${datadog_team.mitch-terraform.handle}"]
}

// Service Definition with v2.2 Schema Definition
resource "datadog_service_definition_yaml" "service_definition_v2_2" {
  service_definition = <<EOF
schema-version: v2.2
dd-service: java-gradle-demo
team: ${datadog_team.mitch-terraform.handle}
contacts:
  - name: Support Email
    type: email
    contact: team@shopping.com
  - name: Support Slack
    type: slack
    contact: https://rapdevio.slack.com/archives/C06JUFEJ69Y
description: demo java gradle app to test different java tracer library config options
tier: high
lifecycle: production
application: java-gradle-demo
languages: 
  - java
type: java 
ci-pipeline-fingerprints:
  - fp1 
  - fp2 
links:
  - name: java-gradle-demo runbook
    type: runbook
    url: https://runbook/foobar
  - name: java-gradle-demo architecture
    type: doc
    provider: gdoc
    url: https://google.drive/
  - name: notion
    type: doc
    provider: notion
    url: https://www.notion.so/Engineering-Wiki-e310290f43214284acb6343639a6f191?pvs=4
  - name: java-gradle-demo source code
    type: repo
    provider: github
    url: https://github.com/mitcherthewitcher/java-gradle-demo
tags:
  - business-unit:datadog-services
  - cost-center:datadog-engineering
integrations:
  pagerduty: 
    service-url: https://www.pagerduty.com/service-directory/Pjava-gradle-demo
extensions:
  mycompany.com/shopping-cart:
    customField: customValue
EOF
}
