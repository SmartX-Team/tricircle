#!/bin/bash -e
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

export DEST=$BASE/new
export DEVSTACK_DIR=$DEST/tricircle/devstack
export TRICIRCLE_DIR=$DEST/tricircle
export TEMPEST_DIR=$DEST/tempest
export TEMPEST_CONF=$TEMPEST_DIR/etc/tempest.conf


# preparation for the tests
cd $TEMPEST_DIR

# Import functions needed for the below workaround
source $DEST/devstack/functions

# add account information to configuration
source $BASE/new/devstack/openrc admin admin
env | grep OS_
iniset $TEMPEST_CONF auth admin_username admin
iniset $TEMPEST_CONF auth admin_project_name admin
iniset $TEMPEST_CONF auth admin_password $OS_PASSWORD
iniset $TEMPEST_CONF identity uri $OS_AUTH_URL
iniset $TEMPEST_CONF identity-feature-enabled api_v3 false

# change the configruation to test Tricircle Cinder-APIGW
iniset $TEMPEST_CONF volume region RegionOne
iniset $TEMPEST_CONF volume catalog_type volumev2
iniset $TEMPEST_CONF volume endpoint_type publicURL
iniset $TEMPEST_CONF volume-feature-enabled api_v1 false

# Run functional test
echo "Running Tricircle functional test suite..."

# all test cases with following prefix
ostestr --regex '(tempest.api.volume.test_volumes_list|\
tempest.api.volume.test_volumes_get)'

# add test_volume_type like this for volume_type test
# ostestr --regex '(tempest.api.volume.test_volumes_list|\
# tempest.api.volume.test_volumes_get|\
# tempest.api.volume.admin.test_volume_type)'

# --------------------- IMPORTANT begin -------------------- #
# all following test cases are from Cinder tempest test cases,
# the purpose to list them here is to check which test cases
# are still not covered and tested in Cinder-APIGW.
#
# Those test cases which have been covered by ostestr running
# above should be marked with **DONE** after the "#".
# please leave the length of each line > 80 characters in order
# to keep one test case one line.
#
# When you add new feature to Cinder-APIGW, please select
# proper test cases to test against the feature, and marked
# these test cases with **DONE** after the "#". For those test
# cases which are not needed to be tested in Cinder-APIGW, for
# example V1(which has been deprecated) should be marked with
# **SKIP** after "#"
#
# The test cases running through ostestr could be filtered
# by regex expression, for example, for Cinder volume type
# releated test cases could be executed by a single clause:
# ostestr --regex tempest.api.volume.admin.test_volume_types
# --------------------- IMPORTANT end -----------------------#


# tempest.api.volume.admin.test_multi_backend.VolumeMultiBackendV1Test.test_backend_name_distinction[id-46435ab1-a0af-4401-8373-f14e66b0dd58]
# tempest.api.volume.admin.test_multi_backend.VolumeMultiBackendV1Test.test_backend_name_distinction_with_prefix[id-4236305b-b65a-4bfc-a9d2-69cb5b2bf2ed]
# tempest.api.volume.admin.test_multi_backend.VolumeMultiBackendV1Test.test_backend_name_reporting[id-c1a41f3f-9dad-493e-9f09-3ff197d477cc]
# tempest.api.volume.admin.test_multi_backend.VolumeMultiBackendV1Test.test_backend_name_reporting_with_prefix[id-f38e647f-ab42-4a31-a2e7-ca86a6485215]
# tempest.api.volume.admin.test_multi_backend.VolumeMultiBackendV2Test.test_backend_name_distinction[id-46435ab1-a0af-4401-8373-f14e66b0dd58]
# tempest.api.volume.admin.test_multi_backend.VolumeMultiBackendV2Test.test_backend_name_distinction_with_prefix[id-4236305b-b65a-4bfc-a9d2-69cb5b2bf2ed]
# tempest.api.volume.admin.test_multi_backend.VolumeMultiBackendV2Test.test_backend_name_reporting[id-c1a41f3f-9dad-493e-9f09-3ff197d477cc]
# tempest.api.volume.admin.test_multi_backend.VolumeMultiBackendV2Test.test_backend_name_reporting_with_prefix[id-f38e647f-ab42-4a31-a2e7-ca86a6485215]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV1Test.test_reset_snapshot_status[id-3e13ca2f-48ea-49f3-ae1a-488e9180d535]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV1Test.test_snapshot_force_delete_when_snapshot_is_creating[id-05f711b6-e629-4895-8103-7ca069f2073a]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV1Test.test_snapshot_force_delete_when_snapshot_is_deleting[id-92ce8597-b992-43a1-8868-6316b22a969e]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV1Test.test_snapshot_force_delete_when_snapshot_is_error[id-645a4a67-a1eb-4e8e-a547-600abac1525d]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV1Test.test_snapshot_force_delete_when_snapshot_is_error_deleting[id-bf89080f-8129-465e-9327-b2f922666ba5]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV1Test.test_update_snapshot_status[id-41288afd-d463-485e-8f6e-4eea159413eb]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV2Test.test_reset_snapshot_status[id-3e13ca2f-48ea-49f3-ae1a-488e9180d535]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV2Test.test_snapshot_force_delete_when_snapshot_is_creating[id-05f711b6-e629-4895-8103-7ca069f2073a]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV2Test.test_snapshot_force_delete_when_snapshot_is_deleting[id-92ce8597-b992-43a1-8868-6316b22a969e]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV2Test.test_snapshot_force_delete_when_snapshot_is_error[id-645a4a67-a1eb-4e8e-a547-600abac1525d]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV2Test.test_snapshot_force_delete_when_snapshot_is_error_deleting[id-bf89080f-8129-465e-9327-b2f922666ba5]
# tempest.api.volume.admin.test_snapshots_actions.SnapshotsActionsV2Test.test_update_snapshot_status[id-41288afd-d463-485e-8f6e-4eea159413eb]
# tempest.api.volume.admin.test_volume_hosts.VolumeHostsAdminV1TestsJSON.test_list_hosts[id-d5f3efa2-6684-4190-9ced-1c2f526352ad]
# tempest.api.volume.admin.test_volume_hosts.VolumeHostsAdminV2TestsJSON.test_list_hosts[id-d5f3efa2-6684-4190-9ced-1c2f526352ad]
# tempest.api.volume.admin.test_volume_quotas.BaseVolumeQuotasAdminV2TestJSON.test_delete_quota[id-874b35a9-51f1-4258-bec5-cd561b6690d3]
# tempest.api.volume.admin.test_volume_quotas.BaseVolumeQuotasAdminV2TestJSON.test_list_default_quotas[id-2be020a2-5fdd-423d-8d35-a7ffbc36e9f7]
# tempest.api.volume.admin.test_volume_quotas.BaseVolumeQuotasAdminV2TestJSON.test_list_quotas[id-59eada70-403c-4cef-a2a3-a8ce2f1b07a0]
# tempest.api.volume.admin.test_volume_quotas.BaseVolumeQuotasAdminV2TestJSON.test_quota_usage[id-ae8b6091-48ad-4bfa-a188-bbf5cc02115f]
# tempest.api.volume.admin.test_volume_quotas.BaseVolumeQuotasAdminV2TestJSON.test_show_quota_usage[id-18c51ae9-cb03-48fc-b234-14a19374dbed]
# tempest.api.volume.admin.test_volume_quotas.BaseVolumeQuotasAdminV2TestJSON.test_update_all_quota_resources_for_tenant[id-3d45c99e-cc42-4424-a56e-5cbd212b63a6]
# tempest.api.volume.admin.test_volume_quotas.VolumeQuotasAdminV1TestJSON.test_delete_quota[id-874b35a9-51f1-4258-bec5-cd561b6690d3]
# tempest.api.volume.admin.test_volume_quotas.VolumeQuotasAdminV1TestJSON.test_list_default_quotas[id-2be020a2-5fdd-423d-8d35-a7ffbc36e9f7]
# tempest.api.volume.admin.test_volume_quotas.VolumeQuotasAdminV1TestJSON.test_list_quotas[id-59eada70-403c-4cef-a2a3-a8ce2f1b07a0]
# tempest.api.volume.admin.test_volume_quotas.VolumeQuotasAdminV1TestJSON.test_quota_usage[id-ae8b6091-48ad-4bfa-a188-bbf5cc02115f]
# tempest.api.volume.admin.test_volume_quotas.VolumeQuotasAdminV1TestJSON.test_show_quota_usage[id-18c51ae9-cb03-48fc-b234-14a19374dbed]
# tempest.api.volume.admin.test_volume_quotas.VolumeQuotasAdminV1TestJSON.test_update_all_quota_resources_for_tenant[id-3d45c99e-cc42-4424-a56e-5cbd212b63a6]
# tempest.api.volume.admin.test_volume_quotas_negative.BaseVolumeQuotasNegativeV2TestJSON.test_quota_volume_gigabytes[id-2dc27eee-8659-4298-b900-169d71a91374,negative]
# tempest.api.volume.admin.test_volume_quotas_negative.BaseVolumeQuotasNegativeV2TestJSON.test_quota_volumes[id-bf544854-d62a-47f2-a681-90f7a47d86b6,negative]
# tempest.api.volume.admin.test_volume_quotas_negative.VolumeQuotasNegativeV1TestJSON.test_quota_volume_gigabytes[id-2dc27eee-8659-4298-b900-169d71a91374,negative]
# tempest.api.volume.admin.test_volume_quotas_negative.VolumeQuotasNegativeV1TestJSON.test_quota_volumes[id-bf544854-d62a-47f2-a681-90f7a47d86b6,negative]
# tempest.api.volume.admin.test_volume_services.VolumesServicesV1TestJSON.test_get_service_by_host_name[id-178710e4-7596-4e08-9333-745cb8bc4f8d]
# tempest.api.volume.admin.test_volume_services.VolumesServicesV1TestJSON.test_get_service_by_service_and_host_name[id-ffa6167c-4497-4944-a464-226bbdb53908]
# tempest.api.volume.admin.test_volume_services.VolumesServicesV1TestJSON.test_get_service_by_service_binary_name[id-63a3e1ca-37ee-4983-826d-83276a370d25]
# tempest.api.volume.admin.test_volume_services.VolumesServicesV1TestJSON.test_list_services[id-e0218299-0a59-4f43-8b2b-f1c035b3d26d]
# tempest.api.volume.admin.test_volume_services.VolumesServicesV2TestJSON.test_get_service_by_host_name[id-178710e4-7596-4e08-9333-745cb8bc4f8d]
# tempest.api.volume.admin.test_volume_services.VolumesServicesV2TestJSON.test_get_service_by_service_and_host_name[id-ffa6167c-4497-4944-a464-226bbdb53908]
# tempest.api.volume.admin.test_volume_services.VolumesServicesV2TestJSON.test_get_service_by_service_binary_name[id-63a3e1ca-37ee-4983-826d-83276a370d25]
# tempest.api.volume.admin.test_volume_services.VolumesServicesV2TestJSON.test_list_services[id-e0218299-0a59-4f43-8b2b-f1c035b3d26d]
# tempest.api.volume.admin.test_volume_snapshot_quotas_negative.VolumeSnapshotNegativeV1TestJSON.test_quota_volume_gigabytes_snapshots[id-c99a1ca9-6cdf-498d-9fdf-25832babef27,negative]
# tempest.api.volume.admin.test_volume_snapshot_quotas_negative.VolumeSnapshotNegativeV1TestJSON.test_quota_volume_snapshots[id-02bbf63f-6c05-4357-9d98-2926a94064ff,negative]
# tempest.api.volume.admin.test_volume_snapshot_quotas_negative.VolumeSnapshotQuotasNegativeV2TestJSON.test_quota_volume_gigabytes_snapshots[id-c99a1ca9-6cdf-498d-9fdf-25832babef27,negative]
# tempest.api.volume.admin.test_volume_snapshot_quotas_negative.VolumeSnapshotQuotasNegativeV2TestJSON.test_quota_volume_snapshots[id-02bbf63f-6c05-4357-9d98-2926a94064ff,negative]
# tempest.api.volume.admin.test_volume_types.VolumeTypesV1Test.test_volume_crud_with_volume_type_and_extra_specs[id-c03cc62c-f4e9-4623-91ec-64ce2f9c1260]
# tempest.api.volume.admin.test_volume_types.VolumeTypesV1Test.test_volume_type_create_get_delete[id-4e955c3b-49db-4515-9590-0c99f8e471ad]
# tempest.api.volume.admin.test_volume_types.VolumeTypesV1Test.test_volume_type_encryption_create_get_delete[id-7830abd0-ff99-4793-a265-405684a54d46]
# tempest.api.volume.admin.test_volume_types.VolumeTypesV1Test.test_volume_type_list[id-9d9b28e3-1b2e-4483-a2cc-24aa0ea1de54]
# tempest.api.volume.admin.test_volume_types.VolumeTypesV2Test.test_volume_crud_with_volume_type_and_extra_specs[id-c03cc62c-f4e9-4623-91ec-64ce2f9c1260]
# tempest.api.volume.admin.test_volume_types.VolumeTypesV2Test.test_volume_type_create_get_delete[id-4e955c3b-49db-4515-9590-0c99f8e471ad]
# tempest.api.volume.admin.test_volume_types.VolumeTypesV2Test.test_volume_type_encryption_create_get_delete[id-7830abd0-ff99-4793-a265-405684a54d46]
# tempest.api.volume.admin.test_volume_types.VolumeTypesV2Test.test_volume_type_list[id-9d9b28e3-1b2e-4483-a2cc-24aa0ea1de54]
# tempest.api.volume.admin.test_volume_types_extra_specs.VolumeTypesExtraSpecsV1Test.test_volume_type_extra_spec_create_get_delete[id-d4772798-601f-408a-b2a5-29e8a59d1220]
# tempest.api.volume.admin.test_volume_types_extra_specs.VolumeTypesExtraSpecsV1Test.test_volume_type_extra_specs_list[id-b42923e9-0452-4945-be5b-d362ae533e60]
# tempest.api.volume.admin.test_volume_types_extra_specs.VolumeTypesExtraSpecsV1Test.test_volume_type_extra_specs_update[id-0806db36-b4a0-47a1-b6f3-c2e7f194d017]
# tempest.api.volume.admin.test_volume_types_extra_specs.VolumeTypesExtraSpecsV2Test.test_volume_type_extra_spec_create_get_delete[id-d4772798-601f-408a-b2a5-29e8a59d1220]
# tempest.api.volume.admin.test_volume_types_extra_specs.VolumeTypesExtraSpecsV2Test.test_volume_type_extra_specs_list[id-b42923e9-0452-4945-be5b-d362ae533e60]
# tempest.api.volume.admin.test_volume_types_extra_specs.VolumeTypesExtraSpecsV2Test.test_volume_type_extra_specs_update[id-0806db36-b4a0-47a1-b6f3-c2e7f194d017]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_create_invalid_body[id-bc772c71-1ed4-4716-b945-8b5ed0f15e87]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_create_none_body[id-c821bdc8-43a4-4bf4-86c8-82f3858d5f7d]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_create_nonexistent_type_id[id-49d5472c-a53d-4eab-a4d3-450c4db1c545]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_delete_nonexistent_volume_type_id[id-031cda8b-7d23-4246-8bf6-bbe73fd67074]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_get_nonexistent_extra_spec_id[id-c881797d-12ff-4f1a-b09d-9f6212159753]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_get_nonexistent_volume_type_id[id-9f402cbd-1838-4eb4-9554-126a6b1908c9]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_list_nonexistent_volume_type_id[id-dee5cf0c-cdd6-4353-b70c-e847050d71fb]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_update_multiple_extra_spec[id-a77dfda2-9100-448e-9076-ed1711f4bdfc]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_update_no_body[id-08961d20-5cbb-4910-ac0f-89ad6dbb2da1]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_update_none_extra_spec_id[id-9bf7a657-b011-4aec-866d-81c496fbe5c8]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV1Test.test_update_nonexistent_extra_spec_id[id-25e5a0ee-89b3-4c53-8310-236f76c75365]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_create_invalid_body[id-bc772c71-1ed4-4716-b945-8b5ed0f15e87]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_create_none_body[id-c821bdc8-43a4-4bf4-86c8-82f3858d5f7d]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_create_nonexistent_type_id[id-49d5472c-a53d-4eab-a4d3-450c4db1c545]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_delete_nonexistent_volume_type_id[id-031cda8b-7d23-4246-8bf6-bbe73fd67074]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_get_nonexistent_extra_spec_id[id-c881797d-12ff-4f1a-b09d-9f6212159753]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_get_nonexistent_volume_type_id[id-9f402cbd-1838-4eb4-9554-126a6b1908c9]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_list_nonexistent_volume_type_id[id-dee5cf0c-cdd6-4353-b70c-e847050d71fb]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_update_multiple_extra_spec[id-a77dfda2-9100-448e-9076-ed1711f4bdfc]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_update_no_body[id-08961d20-5cbb-4910-ac0f-89ad6dbb2da1]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_update_none_extra_spec_id[id-9bf7a657-b011-4aec-866d-81c496fbe5c8]
# tempest.api.volume.admin.test_volume_types_extra_specs_negative.ExtraSpecsNegativeV2Test.test_update_nonexistent_extra_spec_id[id-25e5a0ee-89b3-4c53-8310-236f76c75365]
# tempest.api.volume.admin.test_volume_types_negative.VolumeTypesNegativeV1Test.test_create_with_empty_name[id-878b4e57-faa2-4659-b0d1-ce740a06ae81]
# tempest.api.volume.admin.test_volume_types_negative.VolumeTypesNegativeV1Test.test_create_with_nonexistent_volume_type[id-b48c98f2-e662-4885-9b71-032256906314]
# tempest.api.volume.admin.test_volume_types_negative.VolumeTypesNegativeV1Test.test_delete_nonexistent_type_id[id-6b3926d2-7d73-4896-bc3d-e42dfd11a9f6]
# tempest.api.volume.admin.test_volume_types_negative.VolumeTypesNegativeV1Test.test_get_nonexistent_type_id[id-994610d6-0476-4018-a644-a2602ef5d4aa]
# tempest.api.volume.admin.test_volume_types_negative.VolumeTypesNegativeV2Test.test_create_with_empty_name[id-878b4e57-faa2-4659-b0d1-ce740a06ae81]
# tempest.api.volume.admin.test_volume_types_negative.VolumeTypesNegativeV2Test.test_create_with_nonexistent_volume_type[id-b48c98f2-e662-4885-9b71-032256906314]
# tempest.api.volume.admin.test_volume_types_negative.VolumeTypesNegativeV2Test.test_delete_nonexistent_type_id[id-6b3926d2-7d73-4896-bc3d-e42dfd11a9f6]
# tempest.api.volume.admin.test_volume_types_negative.VolumeTypesNegativeV2Test.test_get_nonexistent_type_id[id-994610d6-0476-4018-a644-a2602ef5d4aa]
# tempest.api.volume.admin.test_volumes_actions.VolumesActionsV1Test.test_volume_force_delete_when_volume_is_attaching[id-db8d607a-aa2e-4beb-b51d-d4005c232011]
# tempest.api.volume.admin.test_volumes_actions.VolumesActionsV1Test.test_volume_force_delete_when_volume_is_creating[id-21737d5a-92f2-46d7-b009-a0cc0ee7a570]
# tempest.api.volume.admin.test_volumes_actions.VolumesActionsV1Test.test_volume_force_delete_when_volume_is_error[id-3e33a8a8-afd4-4d64-a86b-c27a185c5a4a]
# tempest.api.volume.admin.test_volumes_actions.VolumesActionsV1Test.test_volume_reset_status[id-d063f96e-a2e0-4f34-8b8a-395c42de1845]
# tempest.api.volume.admin.test_volumes_actions.VolumesActionsV2Test.test_volume_force_delete_when_volume_is_attaching[id-db8d607a-aa2e-4beb-b51d-d4005c232011]
# tempest.api.volume.admin.test_volumes_actions.VolumesActionsV2Test.test_volume_force_delete_when_volume_is_creating[id-21737d5a-92f2-46d7-b009-a0cc0ee7a570]
# tempest.api.volume.admin.test_volumes_actions.VolumesActionsV2Test.test_volume_force_delete_when_volume_is_error[id-3e33a8a8-afd4-4d64-a86b-c27a185c5a4a]
# tempest.api.volume.admin.test_volumes_actions.VolumesActionsV2Test.test_volume_reset_status[id-d063f96e-a2e0-4f34-8b8a-395c42de1845]
# tempest.api.volume.admin.test_volumes_backup.VolumesBackupsV1Test.test_volume_backup_create_get_detailed_list_restore_delete[id-a66eb488-8ee1-47d4-8e9f-575a095728c6]
# tempest.api.volume.admin.test_volumes_backup.VolumesBackupsV1Test.test_volume_backup_export_import[id-a99c54a1-dd80-4724-8a13-13bf58d4068d]
# tempest.api.volume.admin.test_volumes_backup.VolumesBackupsV2Test.test_volume_backup_create_get_detailed_list_restore_delete[id-a66eb488-8ee1-47d4-8e9f-575a095728c6]
# tempest.api.volume.admin.test_volumes_backup.VolumesBackupsV2Test.test_volume_backup_export_import[id-a99c54a1-dd80-4724-8a13-13bf58d4068d]
# tempest.api.volume.test_availability_zone.AvailabilityZoneV1TestJSON.test_get_availability_zone_list[id-01f1ae88-eba9-4c6b-a011-6f7ace06b725]
# tempest.api.volume.test_availability_zone.AvailabilityZoneV2TestJSON.test_get_availability_zone_list[id-01f1ae88-eba9-4c6b-a011-6f7ace06b725]
# tempest.api.volume.test_extensions.ExtensionsV1TestJSON.test_list_extensions[id-94607eb0-43a5-47ca-82aa-736b41bd2e2c]
# tempest.api.volume.test_extensions.ExtensionsV2TestJSON.test_list_extensions[id-94607eb0-43a5-47ca-82aa-736b41bd2e2c]
# tempest.api.volume.test_qos.QosSpecsV1TestJSON.test_associate_disassociate_qos[id-1dd93c76-6420-485d-a771-874044c416ac]
# tempest.api.volume.test_qos.QosSpecsV1TestJSON.test_create_delete_qos_with_back_end_consumer[id-b115cded-8f58-4ee4-aab5-9192cfada08f]
# tempest.api.volume.test_qos.QosSpecsV1TestJSON.test_create_delete_qos_with_both_consumer[id-f88d65eb-ea0d-487d-af8d-71f4011575a4]
# tempest.api.volume.test_qos.QosSpecsV1TestJSON.test_create_delete_qos_with_front_end_consumer[id-7e15f883-4bef-49a9-95eb-f94209a1ced1]
# tempest.api.volume.test_qos.QosSpecsV1TestJSON.test_get_qos[id-7aa214cc-ac1a-4397-931f-3bb2e83bb0fd]
# tempest.api.volume.test_qos.QosSpecsV1TestJSON.test_list_qos[id-75e04226-bcf7-4595-a34b-fdf0736f38fc]
# tempest.api.volume.test_qos.QosSpecsV1TestJSON.test_set_unset_qos_key[id-ed00fd85-4494-45f2-8ceb-9e2048919aed]
# tempest.api.volume.test_qos.QosSpecsV2TestJSON.test_associate_disassociate_qos[id-1dd93c76-6420-485d-a771-874044c416ac]
# tempest.api.volume.test_qos.QosSpecsV2TestJSON.test_create_delete_qos_with_back_end_consumer[id-b115cded-8f58-4ee4-aab5-9192cfada08f]
# tempest.api.volume.test_qos.QosSpecsV2TestJSON.test_create_delete_qos_with_both_consumer[id-f88d65eb-ea0d-487d-af8d-71f4011575a4]
# tempest.api.volume.test_qos.QosSpecsV2TestJSON.test_create_delete_qos_with_front_end_consumer[id-7e15f883-4bef-49a9-95eb-f94209a1ced1]
# tempest.api.volume.test_qos.QosSpecsV2TestJSON.test_get_qos[id-7aa214cc-ac1a-4397-931f-3bb2e83bb0fd]
# tempest.api.volume.test_qos.QosSpecsV2TestJSON.test_list_qos[id-75e04226-bcf7-4595-a34b-fdf0736f38fc]
# tempest.api.volume.test_qos.QosSpecsV2TestJSON.test_set_unset_qos_key[id-ed00fd85-4494-45f2-8ceb-9e2048919aed]
# tempest.api.volume.test_snapshot_metadata.SnapshotV1MetadataTestJSON.test_create_get_delete_snapshot_metadata[id-a2f20f99-e363-4584-be97-bc33afb1a56c]
# tempest.api.volume.test_snapshot_metadata.SnapshotV1MetadataTestJSON.test_update_snapshot_metadata[id-bd2363bc-de92-48a4-bc98-28943c6e4be1]
# tempest.api.volume.test_snapshot_metadata.SnapshotV1MetadataTestJSON.test_update_snapshot_metadata_item[id-e8ff85c5-8f97-477f-806a-3ac364a949ed]
# tempest.api.volume.test_snapshot_metadata.SnapshotV2MetadataTestJSON.test_create_get_delete_snapshot_metadata[id-a2f20f99-e363-4584-be97-bc33afb1a56c]
# tempest.api.volume.test_snapshot_metadata.SnapshotV2MetadataTestJSON.test_update_snapshot_metadata[id-bd2363bc-de92-48a4-bc98-28943c6e4be1]
# tempest.api.volume.test_snapshot_metadata.SnapshotV2MetadataTestJSON.test_update_snapshot_metadata_item[id-e8ff85c5-8f97-477f-806a-3ac364a949ed]
# tempest.api.volume.test_volume_metadata.VolumesV1MetadataTest.test_create_get_delete_volume_metadata[id-6f5b125b-f664-44bf-910f-751591fe5769]
# tempest.api.volume.test_volume_metadata.VolumesV1MetadataTest.test_update_volume_metadata[id-774d2918-9beb-4f30-b3d1-2a4e8179ec0a]
# tempest.api.volume.test_volume_metadata.VolumesV1MetadataTest.test_update_volume_metadata_item[id-862261c5-8df4-475a-8c21-946e50e36a20]
# tempest.api.volume.test_volume_metadata.VolumesV2MetadataTest.test_create_get_delete_volume_metadata[id-6f5b125b-f664-44bf-910f-751591fe5769]
# tempest.api.volume.test_volume_metadata.VolumesV2MetadataTest.test_update_volume_metadata[id-774d2918-9beb-4f30-b3d1-2a4e8179ec0a]
# tempest.api.volume.test_volume_metadata.VolumesV2MetadataTest.test_update_volume_metadata_item[id-862261c5-8df4-475a-8c21-946e50e36a20]
# tempest.api.volume.test_volume_transfers.VolumesV1TransfersTest.test_create_get_list_accept_volume_transfer[id-4d75b645-a478-48b1-97c8-503f64242f1a]
# tempest.api.volume.test_volume_transfers.VolumesV1TransfersTest.test_create_list_delete_volume_transfer[id-ab526943-b725-4c07-b875-8e8ef87a2c30]
# tempest.api.volume.test_volume_transfers.VolumesV2TransfersTest.test_create_get_list_accept_volume_transfer[id-4d75b645-a478-48b1-97c8-503f64242f1a]
# tempest.api.volume.test_volume_transfers.VolumesV2TransfersTest.test_create_list_delete_volume_transfer[id-ab526943-b725-4c07-b875-8e8ef87a2c30]
# tempest.api.volume.test_volumes_actions.VolumesV1ActionsTest.test_attach_detach_volume_to_instance[compute,id-fff42874-7db5-4487-a8e1-ddda5fb5288d,smoke,stress]
# tempest.api.volume.test_volumes_actions.VolumesV1ActionsTest.test_get_volume_attachment[compute,id-9516a2c8-9135-488c-8dd6-5677a7e5f371,stress]
# tempest.api.volume.test_volumes_actions.VolumesV1ActionsTest.test_reserve_unreserve_volume[id-92c4ef64-51b2-40c0-9f7e-4749fbaaba33]
# tempest.api.volume.test_volumes_actions.VolumesV1ActionsTest.test_volume_bootable[id-63e21b4c-0a0c-41f6-bfc3-7c2816815599]
# tempest.api.volume.test_volumes_actions.VolumesV1ActionsTest.test_volume_readonly_update[id-fff74e1e-5bd3-4b33-9ea9-24c103bc3f59]
# tempest.api.volume.test_volumes_actions.VolumesV1ActionsTest.test_volume_upload[id-d8f1ca95-3d5b-44a3-b8ca-909691c9532d,image]
# tempest.api.volume.test_volumes_actions.VolumesV2ActionsTest.test_attach_detach_volume_to_instance[compute,id-fff42874-7db5-4487-a8e1-ddda5fb5288d,smoke,stress]
# tempest.api.volume.test_volumes_actions.VolumesV2ActionsTest.test_get_volume_attachment[compute,id-9516a2c8-9135-488c-8dd6-5677a7e5f371,stress]
# tempest.api.volume.test_volumes_actions.VolumesV2ActionsTest.test_reserve_unreserve_volume[id-92c4ef64-51b2-40c0-9f7e-4749fbaaba33]
# tempest.api.volume.test_volumes_actions.VolumesV2ActionsTest.test_volume_bootable[id-63e21b4c-0a0c-41f6-bfc3-7c2816815599]
# tempest.api.volume.test_volumes_actions.VolumesV2ActionsTest.test_volume_readonly_update[id-fff74e1e-5bd3-4b33-9ea9-24c103bc3f59]
# tempest.api.volume.test_volumes_actions.VolumesV2ActionsTest.test_volume_upload[id-d8f1ca95-3d5b-44a3-b8ca-909691c9532d,image]
# tempest.api.volume.test_volumes_extend.VolumesV1ExtendTest.test_volume_extend[id-9a36df71-a257-43a5-9555-dc7c88e66e0e]
# tempest.api.volume.test_volumes_extend.VolumesV2ExtendTest.test_volume_extend[id-9a36df71-a257-43a5-9555-dc7c88e66e0e]
# **SKIP** tempest.api.volume.test_volumes_get.VolumesV1GetTest.test_volume_create_get_update_delete[id-27fb0e9f-fb64-41dd-8bdb-1ffa762f0d51,smoke]
# **SKIP** tempest.api.volume.test_volumes_get.VolumesV1GetTest.test_volume_create_get_update_delete_as_clone[id-3f591b4a-7dc6-444c-bd51-77469506b3a1]
# **SKIP** tempest.api.volume.test_volumes_get.VolumesV1GetTest.test_volume_create_get_update_delete_from_image[id-54a01030-c7fc-447c-86ee-c1182beae638,image,smoke]
# **DONE** tempest.api.volume.test_volumes_get.VolumesV2GetTest.test_volume_create_get_update_delete[id-27fb0e9f-fb64-41dd-8bdb-1ffa762f0d51,smoke]
# **DONE** tempest.api.volume.test_volumes_get.VolumesV2GetTest.test_volume_create_get_update_delete_as_clone[id-3f591b4a-7dc6-444c-bd51-77469506b3a1]
# **DONE** tempest.api.volume.test_volumes_get.VolumesV2GetTest.test_volume_create_get_update_delete_from_image[id-54a01030-c7fc-447c-86ee-c1182beae638,image,smoke]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volume_list[id-0b6ddd39-b948-471f-8038-4787978747c4,smoke]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volume_list_by_name[id-a28e8da4-0b56-472f-87a8-0f4d3f819c02]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volume_list_details_by_name[id-2de3a6d4-12aa-403b-a8f2-fdeb42a89623]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volume_list_param_display_name_and_status[id-777c87c1-2fc4-4883-8b8e-5c0b951d1ec8]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volume_list_with_detail_param_display_name_and_status[id-856ab8ca-6009-4c37-b691-be1065528ad4]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volume_list_with_detail_param_metadata[id-1ca92d3c-4a8e-4b43-93f5-e4c7fb3b291d]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volume_list_with_details[id-adcbb5a7-5ad8-4b61-bd10-5380e111a877]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volume_list_with_param_metadata[id-b5ebea1b-0603-40a0-bb41-15fcd0a53214]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volumes_list_by_availability_zone[id-c0cfa863-3020-40d7-b587-e35f597d5d87]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volumes_list_by_status[id-39654e13-734c-4dab-95ce-7613bf8407ce]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volumes_list_details_by_availability_zone[id-e1b80d13-94f0-4ba2-a40e-386af29f8db1]
# **SKIP** tempest.api.volume.test_volumes_list.VolumesV1ListTestJSON.test_volumes_list_details_by_status[id-2943f712-71ec-482a-bf49-d5ca06216b9f]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volume_list[id-0b6ddd39-b948-471f-8038-4787978747c4,smoke]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_by_name[id-a28e8da4-0b56-472f-87a8-0f4d3f819c02]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_details_by_name[id-2de3a6d4-12aa-403b-a8f2-fdeb42a89623]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_param_display_name_and_status[id-777c87c1-2fc4-4883-8b8e-5c0b951d1ec8]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_with_detail_param_display_name_and_status[id-856ab8ca-6009-4c37-b691-be1065528ad4]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_with_detail_param_metadata[id-1ca92d3c-4a8e-4b43-93f5-e4c7fb3b291d]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_with_details[id-adcbb5a7-5ad8-4b61-bd10-5380e111a877]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_with_param_metadata[id-b5ebea1b-0603-40a0-bb41-15fcd0a53214]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volumes_list_by_availability_zone[id-c0cfa863-3020-40d7-b587-e35f597d5d87]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volumes_list_by_status[id-39654e13-734c-4dab-95ce-7613bf8407ce]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volumes_list_details_by_availability_zone[id-e1b80d13-94f0-4ba2-a40e-386af29f8db1]
# **DONE** tempest.api.volume.test_volumes_list.VolumesV2ListTestJSON.test_volumes_list_details_by_status[id-2943f712-71ec-482a-bf49-d5ca06216b9f]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_attach_volumes_with_nonexistent_volume_id[compute,id-f5e56b0a-5d02-43c1-a2a7-c9b792c2e3f6,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_create_volume_with_invalid_size[id-1ed83a8a-682d-4dfb-a30e-ee63ffd6c049,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_create_volume_with_nonexistent_snapshot_id[id-0c36f6ae-4604-4017-b0a9-34fdc63096f9,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_create_volume_with_nonexistent_source_volid[id-47c73e08-4be8-45bb-bfdf-0c4e79b88344,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_create_volume_with_nonexistent_volume_type[id-10254ed8-3849-454e-862e-3ab8e6aa01d2,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_create_volume_with_out_passing_size[id-9387686f-334f-4d31-a439-33494b9e2683,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_create_volume_with_size_negative[id-8b472729-9eba-446e-a83b-916bdb34bef7,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_create_volume_with_size_zero[id-41331caa-eaf4-4001-869d-bc18c1869360,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_delete_invalid_volume_id[id-1f035827-7c32-4019-9240-b4ec2dbd9dfd,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_delete_volume_without_passing_volume_id[id-441a1550-5d44-4b30-af0f-a6d402f52026,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_detach_volumes_with_invalid_volume_id[id-9f9c24e4-011d-46b5-b992-952140ce237a,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_get_invalid_volume_id[id-30799cfd-7ee4-446c-b66c-45b383ed211b,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_get_volume_without_passing_volume_id[id-c6c3db06-29ad-4e91-beb0-2ab195fe49e3,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_list_volumes_detail_with_invalid_status[id-ba94b27b-be3f-496c-a00e-0283b373fa75,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_list_volumes_detail_with_nonexistent_name[id-9ca17820-a0e7-4cbd-a7fa-f4468735e359,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_list_volumes_with_invalid_status[id-143b279b-7522-466b-81be-34a87d564a7c,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_list_volumes_with_nonexistent_name[id-0f4aa809-8c7b-418f-8fb3-84c7a5dfc52f,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_reserve_volume_with_negative_volume_status[id-449c4ed2-ecdd-47bb-98dc-072aeccf158c,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_reserve_volume_with_nonexistent_volume_id[id-ac6084c0-0546-45f9-b284-38a367e0e0e2,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_unreserve_volume_with_nonexistent_volume_id[id-eb467654-3dc1-4a72-9b46-47c29d22654c,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_update_volume_with_empty_volume_id[id-72aeca85-57a5-4c1f-9057-f320f9ea575b,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_update_volume_with_invalid_volume_id[id-e66e40d6-65e6-4e75-bdc7-636792fa152d,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_update_volume_with_nonexistent_volume_id[id-0186422c-999a-480e-a026-6a665744c30c,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_volume_delete_nonexistent_volume_id[id-555efa6e-efcd-44ef-8a3b-4a7ca4837a29,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_volume_extend_with_None_size[id-355218f1-8991-400a-a6bb-971239287d92,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_volume_extend_with_non_number_size[id-5d0b480d-e833-439f-8a5a-96ad2ed6f22f,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_volume_extend_with_nonexistent_volume_id[id-8f05a943-013c-4063-ac71-7baf561e82eb,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_volume_extend_with_size_smaller_than_original_size[id-e0c75c74-ee34-41a9-9288-2a2051452854,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_volume_extend_without_passing_volume_id[id-aff8ba64-6d6f-4f2e-bc33-41a08ee9f115,negative]
# tempest.api.volume.test_volumes_negative.VolumesV1NegativeTest.test_volume_get_nonexistent_volume_id[id-f131c586-9448-44a4-a8b0-54ca838aa43e,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_attach_volumes_with_nonexistent_volume_id[compute,id-f5e56b0a-5d02-43c1-a2a7-c9b792c2e3f6,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_create_volume_with_invalid_size[id-1ed83a8a-682d-4dfb-a30e-ee63ffd6c049,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_create_volume_with_nonexistent_snapshot_id[id-0c36f6ae-4604-4017-b0a9-34fdc63096f9,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_create_volume_with_nonexistent_source_volid[id-47c73e08-4be8-45bb-bfdf-0c4e79b88344,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_create_volume_with_nonexistent_volume_type[id-10254ed8-3849-454e-862e-3ab8e6aa01d2,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_create_volume_with_out_passing_size[id-9387686f-334f-4d31-a439-33494b9e2683,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_create_volume_with_size_negative[id-8b472729-9eba-446e-a83b-916bdb34bef7,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_create_volume_with_size_zero[id-41331caa-eaf4-4001-869d-bc18c1869360,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_delete_invalid_volume_id[id-1f035827-7c32-4019-9240-b4ec2dbd9dfd,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_delete_volume_without_passing_volume_id[id-441a1550-5d44-4b30-af0f-a6d402f52026,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_detach_volumes_with_invalid_volume_id[id-9f9c24e4-011d-46b5-b992-952140ce237a,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_get_invalid_volume_id[id-30799cfd-7ee4-446c-b66c-45b383ed211b,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_get_volume_without_passing_volume_id[id-c6c3db06-29ad-4e91-beb0-2ab195fe49e3,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_list_volumes_detail_with_invalid_status[id-ba94b27b-be3f-496c-a00e-0283b373fa75,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_list_volumes_detail_with_nonexistent_name[id-9ca17820-a0e7-4cbd-a7fa-f4468735e359,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_list_volumes_with_invalid_status[id-143b279b-7522-466b-81be-34a87d564a7c,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_list_volumes_with_nonexistent_name[id-0f4aa809-8c7b-418f-8fb3-84c7a5dfc52f,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_reserve_volume_with_negative_volume_status[id-449c4ed2-ecdd-47bb-98dc-072aeccf158c,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_reserve_volume_with_nonexistent_volume_id[id-ac6084c0-0546-45f9-b284-38a367e0e0e2,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_unreserve_volume_with_nonexistent_volume_id[id-eb467654-3dc1-4a72-9b46-47c29d22654c,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_update_volume_with_empty_volume_id[id-72aeca85-57a5-4c1f-9057-f320f9ea575b,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_update_volume_with_invalid_volume_id[id-e66e40d6-65e6-4e75-bdc7-636792fa152d,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_update_volume_with_nonexistent_volume_id[id-0186422c-999a-480e-a026-6a665744c30c,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_volume_delete_nonexistent_volume_id[id-555efa6e-efcd-44ef-8a3b-4a7ca4837a29,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_volume_extend_with_None_size[id-355218f1-8991-400a-a6bb-971239287d92,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_volume_extend_with_non_number_size[id-5d0b480d-e833-439f-8a5a-96ad2ed6f22f,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_volume_extend_with_nonexistent_volume_id[id-8f05a943-013c-4063-ac71-7baf561e82eb,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_volume_extend_with_size_smaller_than_original_size[id-e0c75c74-ee34-41a9-9288-2a2051452854,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_volume_extend_without_passing_volume_id[id-aff8ba64-6d6f-4f2e-bc33-41a08ee9f115,negative]
# tempest.api.volume.test_volumes_negative.VolumesV2NegativeTest.test_volume_get_nonexistent_volume_id[id-f131c586-9448-44a4-a8b0-54ca838aa43e,negative]
# tempest.api.volume.test_volumes_snapshots.VolumesV1SnapshotTestJSON.test_snapshot_create_get_list_update_delete[id-2a8abbe4-d871-46db-b049-c41f5af8216e]
# tempest.api.volume.test_volumes_snapshots.VolumesV1SnapshotTestJSON.test_snapshot_create_with_volume_in_use[compute,id-b467b54c-07a4-446d-a1cf-651dedcc3ff1]
# tempest.api.volume.test_volumes_snapshots.VolumesV1SnapshotTestJSON.test_snapshot_list_param_limit[id-db4d8e0a-7a2e-41cc-a712-961f6844e896]
# tempest.api.volume.test_volumes_snapshots.VolumesV1SnapshotTestJSON.test_snapshot_list_param_limit_equals_infinite[id-a1427f61-420e-48a5-b6e3-0b394fa95400]
# tempest.api.volume.test_volumes_snapshots.VolumesV1SnapshotTestJSON.test_snapshot_list_param_limit_equals_zero[id-e3b44b7f-ae87-45b5-8a8c-66110eb24d0a]
# tempest.api.volume.test_volumes_snapshots.VolumesV1SnapshotTestJSON.test_snapshots_list_details_with_params[id-220a1022-1fcd-4a74-a7bd-6b859156cda2]
# tempest.api.volume.test_volumes_snapshots.VolumesV1SnapshotTestJSON.test_snapshots_list_with_params[id-59f41f43-aebf-48a9-ab5d-d76340fab32b]
# tempest.api.volume.test_volumes_snapshots.VolumesV1SnapshotTestJSON.test_volume_from_snapshot[id-677863d1-3142-456d-b6ac-9924f667a7f4]
# tempest.api.volume.test_volumes_snapshots.VolumesV2SnapshotTestJSON.test_snapshot_create_get_list_update_delete[id-2a8abbe4-d871-46db-b049-c41f5af8216e]
# tempest.api.volume.test_volumes_snapshots.VolumesV2SnapshotTestJSON.test_snapshot_create_with_volume_in_use[compute,id-b467b54c-07a4-446d-a1cf-651dedcc3ff1]
# tempest.api.volume.test_volumes_snapshots.VolumesV2SnapshotTestJSON.test_snapshot_list_param_limit[id-db4d8e0a-7a2e-41cc-a712-961f6844e896]
# tempest.api.volume.test_volumes_snapshots.VolumesV2SnapshotTestJSON.test_snapshot_list_param_limit_equals_infinite[id-a1427f61-420e-48a5-b6e3-0b394fa95400]
# tempest.api.volume.test_volumes_snapshots.VolumesV2SnapshotTestJSON.test_snapshot_list_param_limit_equals_zero[id-e3b44b7f-ae87-45b5-8a8c-66110eb24d0a]
# tempest.api.volume.test_volumes_snapshots.VolumesV2SnapshotTestJSON.test_snapshots_list_details_with_params[id-220a1022-1fcd-4a74-a7bd-6b859156cda2]
# tempest.api.volume.test_volumes_snapshots.VolumesV2SnapshotTestJSON.test_snapshots_list_with_params[id-59f41f43-aebf-48a9-ab5d-d76340fab32b]
# tempest.api.volume.test_volumes_snapshots.VolumesV2SnapshotTestJSON.test_volume_from_snapshot[id-677863d1-3142-456d-b6ac-9924f667a7f4]
# tempest.api.volume.test_volumes_snapshots_negative.VolumesV1SnapshotNegativeTestJSON.test_create_snapshot_with_nonexistent_volume_id[id-e3e466af-70ab-4f4b-a967-ab04e3532ea7,negative]
# tempest.api.volume.test_volumes_snapshots_negative.VolumesV1SnapshotNegativeTestJSON.test_create_snapshot_without_passing_volume_id[id-bb9da53e-d335-4309-9c15-7e76fd5e4d6d,negative]
# tempest.api.volume.test_volumes_snapshots_negative.VolumesV2SnapshotNegativeTestJSON.test_create_snapshot_with_nonexistent_volume_id[id-e3e466af-70ab-4f4b-a967-ab04e3532ea7,negative]
# tempest.api.volume.test_volumes_snapshots_negative.VolumesV2SnapshotNegativeTestJSON.test_create_snapshot_without_passing_volume_id[id-bb9da53e-d335-4309-9c15-7e76fd5e4d6d,negative]
# tempest.api.volume.v2.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_details_pagination[id-e9138a2c-f67b-4796-8efa-635c196d01de]
# tempest.api.volume.v2.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_details_with_multiple_params[id-2a7064eb-b9c3-429b-b888-33928fc5edd3]
# tempest.api.volume.v2.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_pagination[id-af55e775-8e4b-4feb-8719-215c43b0238c]
# tempest.api.volume.v2.test_volumes_list.VolumesV2ListTestJSON.test_volume_list_with_detail_param_marker[id-46eff077-100b-427f-914e-3db2abcdb7e2]