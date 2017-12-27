# This is to solve issue #21
# We add 2 indexes to speed up the login query

# We drop the index created in DB v2.10: we have a more efficient solution
ALTER TABLE group_group_map DROP KEY group_group_map_grant_type_member_id;

# Add the indexes we need.
CREATE INDEX `group_group_map_member_id_grant_type_idx` ON group_group_map (`member_id`,`grant_type`);
CREATE INDEX `group_group_map_grantor_id_grant_type_idx` ON group_group_map (`grantor_id`,`grant_type`);

# Remove the unnecessary index (see issue #21)
# This is still WIP as we would like to  understand the impact of loosing the unique key unique (member_id,grantor_id,grant_type) for the table.
ALTER TABLE group_group_map DROP KEY group_group_map_member_id_idx;