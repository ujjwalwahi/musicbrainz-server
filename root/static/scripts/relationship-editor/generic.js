// This file is part of MusicBrainz, the open internet music database.
// Copyright (C) 2014 MetaBrainz Foundation
// Licensed under the GPL version 2, or (at your option) any later version:
// http://www.gnu.org/licenses/gpl-2.0.txt

var validation = require('../edit/validation.js');

(function (RE) {

    var UI = RE.UI = RE.UI || {};


    RE.GenericEntityViewModel = aclass(RE.ViewModel, {
        fieldName: "rel",

        after$init: function () {
            MB.sourceRelationshipEditor = this;

            var source = this.source;

            this.incompleteRelationships = validation.errorField(
                source.displayableRelationships(this).any(function (r) {
                    return !r.linkTypeID() || !r.target(source).gid;
                })
            );
        },

        openAddDialog: function (source, event) {
            var targetType = _.without(MB.allowedRelations[source.entityType], 'url')[0];

            UI.AddDialog({
                source: source,
                target: MB.entity({}, targetType),
                viewModel: this
            }).open(event.target);
        },

        openEditDialog: function (relationship, event) {
            if (!relationship.removed()) {
                UI.EditDialog({
                    relationship: relationship,
                    source: ko.contextFor(event.target).$parents[1],
                    viewModel: this
                }).open(event.target);
            }
        },

        around$_sortedRelationships: function (supr, relationships, source) {
            if (source.entityType === "series") {
                return supr(relationships, source).sortBy(function (relationship) {
                    if (+source.orderingTypeID() === MB.constants.SERIES_ORDERING_TYPE_AUTOMATIC) {
                        return relationship.paddedSeriesNumber();
                    }
                    return "";
                });
            }
            return supr(relationships, source);
        }
    });


    ko.bindingHandlers.relationshipStyling = {

        update: function (element, valueAccessor) {
            var relationship = ko.unwrap(valueAccessor());
            var added = relationship.added();

            $(element)
                .toggleClass("rel-add", added)
                .toggleClass("rel-remove", relationship.removed())
                .toggleClass("rel-edit", !added && relationship.edited());
        }
    };


    function addHiddenInputs(pushInput, vm, formName) {
        var fieldPrefix = formName + "." + vm.fieldName;
        var relationships = vm.source.relationshipsInViewModel(vm)();
        var index = 0;

        for (var i = 0, len = relationships.length; i < len; i++) {
            var relationship = relationships[i],
                editData = relationship.editData(),
                prefix = fieldPrefix + "." + index;

            if (!editData.linkTypeID) {
                continue;
            }

            if (relationship.id) {
                pushInput(prefix, "relationship_id", relationship.id);
            }

            if (relationship.removed()) {
                pushInput(prefix, "removed", 1);
            }

            pushInput(prefix, "target", relationship.target(vm.source).gid);

            _.each(editData.attributes, function (attribute, i) {
                var attrPrefix = prefix + ".attributes." + i;

                pushInput(attrPrefix, "type.gid", attribute.type.gid);

                if (attribute.credit) {
                    pushInput(attrPrefix, "credited_as", attribute.credit);
                }

                if (attribute.textValue) {
                    pushInput(attrPrefix, "text_value", attribute.textValue);
                }
            });

            var beginDate = editData.beginDate,
                endDate = editData.endDate,
                ended = editData.ended;

            if (beginDate) {
                pushInput(prefix, "period.begin_date.year", beginDate.year);
                pushInput(prefix, "period.begin_date.month", beginDate.month);
                pushInput(prefix, "period.begin_date.day", beginDate.day);
            }

            if (endDate) {
                pushInput(prefix, "period.end_date.year", endDate.year);
                pushInput(prefix, "period.end_date.month", endDate.month);
                pushInput(prefix, "period.end_date.day", endDate.day);
            }

            if (ended) {
                pushInput(prefix, "period.ended", 1);
            }

            if (vm.source !== relationship.entities()[0]) {
                pushInput(prefix, "backward", 1);
            }

            pushInput(prefix, "link_type_id", editData.linkTypeID || "");

            if (relationship.linkTypeInfo().orderableDirection !== 0) {
                if (relationship.added() || relationship.original.linkOrder !== editData.linkOrder) {
                    pushInput(prefix, "link_order", editData.linkOrder);
                }
            }

            index++;
        }
    }

    RE.prepareSubmission = function (formName) {
        var submitted = [];
        var submittedLinks;
        var vm;
        var source = MB.sourceEntity;
        var hiddenInputs = document.createDocumentFragment();
        var fieldCount = 0;

        function pushInput(prefix, name, value) {
            var input = document.createElement("input");
            input.type = "hidden";
            input.name = prefix + "." + name;
            input.value = value;
            hiddenInputs.appendChild(input);
            ++fieldCount;
        }

        $("#page form button[type=submit]").prop("disabled", true);
        $("input[type=hidden]", "#relationship-editor").remove();

        if (vm = MB.sourceRelationshipEditor) {
            addHiddenInputs(pushInput, vm, formName);
            submitted = submitted.concat(source.relationshipsInViewModel(vm)());
        }

        if (submitted.length && MB.hasSessionStorage) {
            sessionStorage.submittedRelationships = JSON.stringify(
                _.map(submitted, function (relationship) {
                    var data = relationship.editData();

                    data.target = relationship.target(source);
                    data.removed = relationship.removed();

                    if (data.entities[1].gid === source.gid) {
                        data.direction = "backward";
                    }

                    return data;
                })
            );
        }

        if (vm = MB.sourceExternalLinksEditor) {
            vm.getFormData(formName + '.url', fieldCount, pushInput);

            if (MB.hasSessionStorage && vm.state.links.size) {
                sessionStorage.submittedLinks = JSON.stringify(vm.state.links.toJS());
            }
        }

        $("#relationship-editor").append(hiddenInputs);
    };

    $(document).on("submit", "#page form:not(#relationship-editor-form)", _.once(function () {
        RE.prepareSubmission($('#relationship-editor').data('form-name'));
    }));

}(MB.relationshipEditor = MB.relationshipEditor || {}));
