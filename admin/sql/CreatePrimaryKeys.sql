-- Automatically generated, do not edit.
\set ON_ERROR_STOP 1

ALTER TABLE annotation ADD CONSTRAINT annotation_pkey PRIMARY KEY (id);
ALTER TABLE application ADD CONSTRAINT application_pkey PRIMARY KEY (id);
ALTER TABLE area ADD CONSTRAINT area_pkey PRIMARY KEY (id);
ALTER TABLE area_alias ADD CONSTRAINT area_alias_pkey PRIMARY KEY (id);
ALTER TABLE area_alias_type ADD CONSTRAINT area_alias_type_pkey PRIMARY KEY (id);
ALTER TABLE area_annotation ADD CONSTRAINT area_annotation_pkey PRIMARY KEY (area, annotation);
ALTER TABLE area_gid_redirect ADD CONSTRAINT area_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE area_type ADD CONSTRAINT area_type_pkey PRIMARY KEY (id);
ALTER TABLE artist ADD CONSTRAINT artist_pkey PRIMARY KEY (id);
ALTER TABLE artist_alias ADD CONSTRAINT artist_alias_pkey PRIMARY KEY (id);
ALTER TABLE artist_alias_type ADD CONSTRAINT artist_alias_type_pkey PRIMARY KEY (id);
ALTER TABLE artist_annotation ADD CONSTRAINT artist_annotation_pkey PRIMARY KEY (artist, annotation);
ALTER TABLE artist_credit ADD CONSTRAINT artist_credit_pkey PRIMARY KEY (id);
ALTER TABLE artist_credit_name ADD CONSTRAINT artist_credit_name_pkey PRIMARY KEY (artist_credit, position);
ALTER TABLE artist_gid_redirect ADD CONSTRAINT artist_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE artist_ipi ADD CONSTRAINT artist_ipi_pkey PRIMARY KEY (artist, ipi);
ALTER TABLE artist_isni ADD CONSTRAINT artist_isni_pkey PRIMARY KEY (artist, isni);
ALTER TABLE artist_meta ADD CONSTRAINT artist_meta_pkey PRIMARY KEY (id);
ALTER TABLE artist_name ADD CONSTRAINT artist_name_pkey PRIMARY KEY (id);
ALTER TABLE artist_rating_raw ADD CONSTRAINT artist_rating_raw_pkey PRIMARY KEY (artist, editor);
ALTER TABLE artist_tag ADD CONSTRAINT artist_tag_pkey PRIMARY KEY (artist, tag);
ALTER TABLE artist_tag_raw ADD CONSTRAINT artist_tag_raw_pkey PRIMARY KEY (artist, editor, tag);
ALTER TABLE artist_type ADD CONSTRAINT artist_type_pkey PRIMARY KEY (id);
ALTER TABLE autoeditor_election ADD CONSTRAINT autoeditor_election_pkey PRIMARY KEY (id);
ALTER TABLE autoeditor_election_vote ADD CONSTRAINT autoeditor_election_vote_pkey PRIMARY KEY (id);
ALTER TABLE cdtoc ADD CONSTRAINT cdtoc_pkey PRIMARY KEY (id);
ALTER TABLE cdtoc_raw ADD CONSTRAINT cdtoc_raw_pkey PRIMARY KEY (id);
ALTER TABLE clientversion ADD CONSTRAINT clientversion_pkey PRIMARY KEY (id);
ALTER TABLE country_area ADD CONSTRAINT country_area_pkey PRIMARY KEY (area);
ALTER TABLE edit ADD CONSTRAINT edit_pkey PRIMARY KEY (id);
ALTER TABLE edit_artist ADD CONSTRAINT edit_artist_pkey PRIMARY KEY (edit, artist);
ALTER TABLE edit_label ADD CONSTRAINT edit_label_pkey PRIMARY KEY (edit, label);
ALTER TABLE edit_note ADD CONSTRAINT edit_note_pkey PRIMARY KEY (id);
ALTER TABLE edit_recording ADD CONSTRAINT edit_recording_pkey PRIMARY KEY (edit, recording);
ALTER TABLE edit_release ADD CONSTRAINT edit_release_pkey PRIMARY KEY (edit, release);
ALTER TABLE edit_release_group ADD CONSTRAINT edit_release_group_pkey PRIMARY KEY (edit, release_group);
ALTER TABLE edit_url ADD CONSTRAINT edit_url_pkey PRIMARY KEY (edit, url);
ALTER TABLE edit_work ADD CONSTRAINT edit_work_pkey PRIMARY KEY (edit, work);
ALTER TABLE editor ADD CONSTRAINT editor_pkey PRIMARY KEY (id);
ALTER TABLE editor_collection ADD CONSTRAINT editor_collection_pkey PRIMARY KEY (id);
ALTER TABLE editor_collection_release ADD CONSTRAINT editor_collection_release_pkey PRIMARY KEY (collection, release);
ALTER TABLE editor_language ADD CONSTRAINT editor_language_pkey PRIMARY KEY (editor, language);
ALTER TABLE editor_oauth_token ADD CONSTRAINT editor_oauth_token_pkey PRIMARY KEY (id);
ALTER TABLE editor_preference ADD CONSTRAINT editor_preference_pkey PRIMARY KEY (id);
ALTER TABLE editor_subscribe_artist ADD CONSTRAINT editor_subscribe_artist_pkey PRIMARY KEY (id);
ALTER TABLE editor_subscribe_collection ADD CONSTRAINT editor_subscribe_collection_pkey PRIMARY KEY (id);
ALTER TABLE editor_subscribe_editor ADD CONSTRAINT editor_subscribe_editor_pkey PRIMARY KEY (id);
ALTER TABLE editor_subscribe_label ADD CONSTRAINT editor_subscribe_label_pkey PRIMARY KEY (id);
ALTER TABLE editor_watch_artist ADD CONSTRAINT editor_watch_artist_pkey PRIMARY KEY (artist, editor);
ALTER TABLE editor_watch_preferences ADD CONSTRAINT editor_watch_preferences_pkey PRIMARY KEY (editor);
ALTER TABLE editor_watch_release_group_type ADD CONSTRAINT editor_watch_release_group_type_pkey PRIMARY KEY (editor, release_group_type);
ALTER TABLE editor_watch_release_status ADD CONSTRAINT editor_watch_release_status_pkey PRIMARY KEY (editor, release_status);
ALTER TABLE gender ADD CONSTRAINT gender_pkey PRIMARY KEY (id);
ALTER TABLE iso_3166_1 ADD CONSTRAINT iso_3166_1_pkey PRIMARY KEY (code);
ALTER TABLE iso_3166_2 ADD CONSTRAINT iso_3166_2_pkey PRIMARY KEY (code);
ALTER TABLE iso_3166_3 ADD CONSTRAINT iso_3166_3_pkey PRIMARY KEY (code);
ALTER TABLE isrc ADD CONSTRAINT isrc_pkey PRIMARY KEY (id);
ALTER TABLE iswc ADD CONSTRAINT iswc_pkey PRIMARY KEY (id);
ALTER TABLE l_area_area ADD CONSTRAINT l_area_area_pkey PRIMARY KEY (id);
ALTER TABLE l_area_artist ADD CONSTRAINT l_area_artist_pkey PRIMARY KEY (id);
ALTER TABLE l_area_label ADD CONSTRAINT l_area_label_pkey PRIMARY KEY (id);
ALTER TABLE l_area_recording ADD CONSTRAINT l_area_recording_pkey PRIMARY KEY (id);
ALTER TABLE l_area_release ADD CONSTRAINT l_area_release_pkey PRIMARY KEY (id);
ALTER TABLE l_area_release_group ADD CONSTRAINT l_area_release_group_pkey PRIMARY KEY (id);
ALTER TABLE l_area_url ADD CONSTRAINT l_area_url_pkey PRIMARY KEY (id);
ALTER TABLE l_area_work ADD CONSTRAINT l_area_work_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_artist ADD CONSTRAINT l_artist_artist_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_label ADD CONSTRAINT l_artist_label_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_recording ADD CONSTRAINT l_artist_recording_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_release ADD CONSTRAINT l_artist_release_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_release_group ADD CONSTRAINT l_artist_release_group_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_url ADD CONSTRAINT l_artist_url_pkey PRIMARY KEY (id);
ALTER TABLE l_artist_work ADD CONSTRAINT l_artist_work_pkey PRIMARY KEY (id);
ALTER TABLE l_label_label ADD CONSTRAINT l_label_label_pkey PRIMARY KEY (id);
ALTER TABLE l_label_recording ADD CONSTRAINT l_label_recording_pkey PRIMARY KEY (id);
ALTER TABLE l_label_release ADD CONSTRAINT l_label_release_pkey PRIMARY KEY (id);
ALTER TABLE l_label_release_group ADD CONSTRAINT l_label_release_group_pkey PRIMARY KEY (id);
ALTER TABLE l_label_url ADD CONSTRAINT l_label_url_pkey PRIMARY KEY (id);
ALTER TABLE l_label_work ADD CONSTRAINT l_label_work_pkey PRIMARY KEY (id);
ALTER TABLE l_recording_recording ADD CONSTRAINT l_recording_recording_pkey PRIMARY KEY (id);
ALTER TABLE l_recording_release ADD CONSTRAINT l_recording_release_pkey PRIMARY KEY (id);
ALTER TABLE l_recording_release_group ADD CONSTRAINT l_recording_release_group_pkey PRIMARY KEY (id);
ALTER TABLE l_recording_url ADD CONSTRAINT l_recording_url_pkey PRIMARY KEY (id);
ALTER TABLE l_recording_work ADD CONSTRAINT l_recording_work_pkey PRIMARY KEY (id);
ALTER TABLE l_release_group_release_group ADD CONSTRAINT l_release_group_release_group_pkey PRIMARY KEY (id);
ALTER TABLE l_release_group_url ADD CONSTRAINT l_release_group_url_pkey PRIMARY KEY (id);
ALTER TABLE l_release_group_work ADD CONSTRAINT l_release_group_work_pkey PRIMARY KEY (id);
ALTER TABLE l_release_release ADD CONSTRAINT l_release_release_pkey PRIMARY KEY (id);
ALTER TABLE l_release_release_group ADD CONSTRAINT l_release_release_group_pkey PRIMARY KEY (id);
ALTER TABLE l_release_url ADD CONSTRAINT l_release_url_pkey PRIMARY KEY (id);
ALTER TABLE l_release_work ADD CONSTRAINT l_release_work_pkey PRIMARY KEY (id);
ALTER TABLE l_url_url ADD CONSTRAINT l_url_url_pkey PRIMARY KEY (id);
ALTER TABLE l_url_work ADD CONSTRAINT l_url_work_pkey PRIMARY KEY (id);
ALTER TABLE l_work_work ADD CONSTRAINT l_work_work_pkey PRIMARY KEY (id);
ALTER TABLE label ADD CONSTRAINT label_pkey PRIMARY KEY (id);
ALTER TABLE label_alias ADD CONSTRAINT label_alias_pkey PRIMARY KEY (id);
ALTER TABLE label_alias_type ADD CONSTRAINT label_alias_type_pkey PRIMARY KEY (id);
ALTER TABLE label_annotation ADD CONSTRAINT label_annotation_pkey PRIMARY KEY (label, annotation);
ALTER TABLE label_gid_redirect ADD CONSTRAINT label_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE label_ipi ADD CONSTRAINT label_ipi_pkey PRIMARY KEY (label, ipi);
ALTER TABLE label_isni ADD CONSTRAINT label_isni_pkey PRIMARY KEY (label, isni);
ALTER TABLE label_meta ADD CONSTRAINT label_meta_pkey PRIMARY KEY (id);
ALTER TABLE label_name ADD CONSTRAINT label_name_pkey PRIMARY KEY (id);
ALTER TABLE label_rating_raw ADD CONSTRAINT label_rating_raw_pkey PRIMARY KEY (label, editor);
ALTER TABLE label_tag ADD CONSTRAINT label_tag_pkey PRIMARY KEY (label, tag);
ALTER TABLE label_tag_raw ADD CONSTRAINT label_tag_raw_pkey PRIMARY KEY (label, editor, tag);
ALTER TABLE label_type ADD CONSTRAINT label_type_pkey PRIMARY KEY (id);
ALTER TABLE language ADD CONSTRAINT language_pkey PRIMARY KEY (id);
ALTER TABLE link ADD CONSTRAINT link_pkey PRIMARY KEY (id);
ALTER TABLE link_attribute ADD CONSTRAINT link_attribute_pkey PRIMARY KEY (link, attribute_type);
ALTER TABLE link_attribute_credit ADD CONSTRAINT link_attribute_credit_pkey PRIMARY KEY (link, attribute_type);
ALTER TABLE link_attribute_type ADD CONSTRAINT link_attribute_type_pkey PRIMARY KEY (id);
ALTER TABLE link_creditable_attribute_type ADD CONSTRAINT link_creditable_attribute_type_pkey PRIMARY KEY (attribute_type);
ALTER TABLE link_type ADD CONSTRAINT link_type_pkey PRIMARY KEY (id);
ALTER TABLE link_type_attribute_type ADD CONSTRAINT link_type_attribute_type_pkey PRIMARY KEY (link_type, attribute_type);
ALTER TABLE medium ADD CONSTRAINT medium_pkey PRIMARY KEY (id);
ALTER TABLE medium_cdtoc ADD CONSTRAINT medium_cdtoc_pkey PRIMARY KEY (id);
ALTER TABLE medium_format ADD CONSTRAINT medium_format_pkey PRIMARY KEY (id);
ALTER TABLE medium_index ADD CONSTRAINT medium_index_pkey PRIMARY KEY (medium);
ALTER TABLE puid ADD CONSTRAINT puid_pkey PRIMARY KEY (id);
ALTER TABLE recording ADD CONSTRAINT recording_pkey PRIMARY KEY (id);
ALTER TABLE recording_annotation ADD CONSTRAINT recording_annotation_pkey PRIMARY KEY (recording, annotation);
ALTER TABLE recording_gid_redirect ADD CONSTRAINT recording_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE recording_meta ADD CONSTRAINT recording_meta_pkey PRIMARY KEY (id);
ALTER TABLE recording_puid ADD CONSTRAINT recording_puid_pkey PRIMARY KEY (id);
ALTER TABLE recording_rating_raw ADD CONSTRAINT recording_rating_raw_pkey PRIMARY KEY (recording, editor);
ALTER TABLE recording_tag ADD CONSTRAINT recording_tag_pkey PRIMARY KEY (recording, tag);
ALTER TABLE recording_tag_raw ADD CONSTRAINT recording_tag_raw_pkey PRIMARY KEY (recording, editor, tag);
ALTER TABLE release ADD CONSTRAINT release_pkey PRIMARY KEY (id);
ALTER TABLE release_annotation ADD CONSTRAINT release_annotation_pkey PRIMARY KEY (release, annotation);
ALTER TABLE release_country ADD CONSTRAINT release_country_pkey PRIMARY KEY (release, country);
ALTER TABLE release_coverart ADD CONSTRAINT release_coverart_pkey PRIMARY KEY (id);
ALTER TABLE release_gid_redirect ADD CONSTRAINT release_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE release_group ADD CONSTRAINT release_group_pkey PRIMARY KEY (id);
ALTER TABLE release_group_annotation ADD CONSTRAINT release_group_annotation_pkey PRIMARY KEY (release_group, annotation);
ALTER TABLE release_group_gid_redirect ADD CONSTRAINT release_group_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE release_group_meta ADD CONSTRAINT release_group_meta_pkey PRIMARY KEY (id);
ALTER TABLE release_group_primary_type ADD CONSTRAINT release_group_primary_type_pkey PRIMARY KEY (id);
ALTER TABLE release_group_rating_raw ADD CONSTRAINT release_group_rating_raw_pkey PRIMARY KEY (release_group, editor);
ALTER TABLE release_group_secondary_type ADD CONSTRAINT release_group_secondary_type_pkey PRIMARY KEY (id);
ALTER TABLE release_group_secondary_type_join ADD CONSTRAINT release_group_secondary_type_join_pkey PRIMARY KEY (release_group, secondary_type);
ALTER TABLE release_group_tag ADD CONSTRAINT release_group_tag_pkey PRIMARY KEY (release_group, tag);
ALTER TABLE release_group_tag_raw ADD CONSTRAINT release_group_tag_raw_pkey PRIMARY KEY (release_group, editor, tag);
ALTER TABLE release_label ADD CONSTRAINT release_label_pkey PRIMARY KEY (id);
ALTER TABLE release_meta ADD CONSTRAINT release_meta_pkey PRIMARY KEY (id);
ALTER TABLE release_name ADD CONSTRAINT release_name_pkey PRIMARY KEY (id);
ALTER TABLE release_packaging ADD CONSTRAINT release_packaging_pkey PRIMARY KEY (id);
ALTER TABLE release_raw ADD CONSTRAINT release_raw_pkey PRIMARY KEY (id);
ALTER TABLE release_status ADD CONSTRAINT release_status_pkey PRIMARY KEY (id);
ALTER TABLE release_tag ADD CONSTRAINT release_tag_pkey PRIMARY KEY (release, tag);
ALTER TABLE release_tag_raw ADD CONSTRAINT release_tag_raw_pkey PRIMARY KEY (release, editor, tag);
ALTER TABLE release_unknown_country ADD CONSTRAINT release_unknown_country_pkey PRIMARY KEY (release);
ALTER TABLE replication_control ADD CONSTRAINT replication_control_pkey PRIMARY KEY (id);
ALTER TABLE script ADD CONSTRAINT script_pkey PRIMARY KEY (id);
ALTER TABLE script_language ADD CONSTRAINT script_language_pkey PRIMARY KEY (id);
ALTER TABLE tag ADD CONSTRAINT tag_pkey PRIMARY KEY (id);
ALTER TABLE tag_relation ADD CONSTRAINT tag_relation_pkey PRIMARY KEY (tag1, tag2);
ALTER TABLE track ADD CONSTRAINT track_pkey PRIMARY KEY (id);
ALTER TABLE track_gid_redirect ADD CONSTRAINT track_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE track_name ADD CONSTRAINT track_name_pkey PRIMARY KEY (id);
ALTER TABLE track_raw ADD CONSTRAINT track_raw_pkey PRIMARY KEY (id);
ALTER TABLE url ADD CONSTRAINT url_pkey PRIMARY KEY (id);
ALTER TABLE url_gid_redirect ADD CONSTRAINT url_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE vote ADD CONSTRAINT vote_pkey PRIMARY KEY (id);
ALTER TABLE work ADD CONSTRAINT work_pkey PRIMARY KEY (id);
ALTER TABLE work_alias ADD CONSTRAINT work_alias_pkey PRIMARY KEY (id);
ALTER TABLE work_alias_type ADD CONSTRAINT work_alias_type_pkey PRIMARY KEY (id);
ALTER TABLE work_annotation ADD CONSTRAINT work_annotation_pkey PRIMARY KEY (work, annotation);
ALTER TABLE work_attribute ADD CONSTRAINT work_attribute_pkey PRIMARY KEY (id);
ALTER TABLE work_attribute_type ADD CONSTRAINT work_attribute_type_pkey PRIMARY KEY (id);
ALTER TABLE work_attribute_type_allowed_value ADD CONSTRAINT work_attribute_type_allowed_value_pkey PRIMARY KEY (id);
ALTER TABLE work_gid_redirect ADD CONSTRAINT work_gid_redirect_pkey PRIMARY KEY (gid);
ALTER TABLE work_meta ADD CONSTRAINT work_meta_pkey PRIMARY KEY (id);
ALTER TABLE work_name ADD CONSTRAINT work_name_pkey PRIMARY KEY (id);
ALTER TABLE work_rating_raw ADD CONSTRAINT work_rating_raw_pkey PRIMARY KEY (work, editor);
ALTER TABLE work_tag ADD CONSTRAINT work_tag_pkey PRIMARY KEY (work, tag);
ALTER TABLE work_tag_raw ADD CONSTRAINT work_tag_raw_pkey PRIMARY KEY (work, editor, tag);
ALTER TABLE work_type ADD CONSTRAINT work_type_pkey PRIMARY KEY (id);
