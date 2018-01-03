resource "google_service_account" "master" {
  account_id   = "${var.prefix}-kubo-master"
  display_name = "${var.prefix} kubo-master"
}

resource "google_service_account" "worker" {
  account_id   = "${var.prefix}-kubo-worker"
  display_name = "${var.prefix} kubo-worker"
}

resource "google_project_iam_policy" "policy" {
  project     = "${var.project_id}"
  policy_data = "${data.google_iam_policy.admin.policy_data}"
}

data "google_iam_policy" "admin" {
  binding {
    role = "roles/compute.storageAdmin"

    members = [
      "serviceAccount:${google_service_account.master.email}",
    ]
  }

  binding {
    role = "roles/compute.networkAdmin"

    members = [
      "serviceAccount:${google_service_account.master.email}",
    ]
  }

  binding {
    role = "roles/compute.securityAdmin"

    members = [
      "serviceAccount:${google_service_account.master.email}",

    ]
  }

  binding {
    role = "roles/compute.instanceAdmin"

    members = [
      "serviceAccount:${google_service_account.master.email}",
    ]
  }

  binding {
    role = "roles/iam.serviceAccountActor"

    members = [
      "serviceAccount:${google_service_account.master.email}",
    ]
  }

  binding {
    role = "roles/compute.viewer"

    members = [
      "serviceAccount:${google_service_account.worker.email}",
    ]
  }
}
