import json
from unittest import TestCase

from cn.survey.app.v1 import survey_app_pb2
from cn.survey.physician.v1 import survey_physician_pb2
from cn.survey.v1 import survey_do_not_publish_pb2
from cn_proto_utils.utils import generate_struct_type


class TestProtoHelpers(TestCase):
    def test_blah(self):
        from cn_proto_utils.service import SchemaRegistryService

        buf_api = SchemaRegistryService(
            "47de4c094edd4ec3a27d756c4c56e744506072b93e13496a90e5cab1c5781072"
        )
        #
        module = "buf.build/clinician-nexus/app-shared-protobuffs"
        symbol = "cn.survey.app.v1"
        message_name = "AppIncumbentSourceOriented"
        r = buf_api.get_message_descriptor_proto(
            module=module, symbol=symbol, message_name=message_name
        )
        print(r.field[16].options)

    def test_includes_metadata(self):
        st = generate_struct_type(survey_physician_pb2.PhysicianIncumbentSourceOriented)
        assert st[0].metadata == {
            "display_name": "Organization ID (Required)",
            "is_required": True,
            "is_key_field": True,
        }
        assert st[0].nullable == False

    def test_scratch(self):
        st = generate_struct_type(survey_physician_pb2.PhysicianIncumbentSourceOriented)
        print(
            f"PhysicianIncumbentSourceOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )
        st = generate_struct_type(survey_physician_pb2.PhysicianIncumbentDomainOriented)
        print(
            f"PhysicianIncumbentDomainOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )

        st = generate_struct_type(survey_physician_pb2.PhysicianNewHireSourceOriented)
        print(
            f"PhysicianNewHireSourceOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )
        st = generate_struct_type(survey_physician_pb2.PhysicianNewHireDomainOriented)
        print(
            f"PhysicianNewHireDomainOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )

        st = generate_struct_type(survey_app_pb2.AppIncumbentSourceOriented)
        print(
            f"AppIncumbentSourceOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )
        st = generate_struct_type(survey_app_pb2.AppIncumbentDomainOriented)
        print(
            f"AppIncumbentDomainOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )

        st = generate_struct_type(survey_app_pb2.AppNewHireSourceOriented)
        print(
            f"AppNewHireSourceOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )
        st = generate_struct_type(survey_app_pb2.AppNewHireDomainOriented)
        print(
            f"AppNewHireDomainOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )

        st = generate_struct_type(survey_app_pb2.AppCallPaySourceOriented)
        print(
            f"AppCallPaySourceOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )
        st = generate_struct_type(survey_app_pb2.AppCallPayDomainOriented)
        print(
            f"AppCallPayDomainOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )

        st = generate_struct_type(survey_app_pb2.AppSalaryGradesAndRangesSourceOriented)
        print(
            f"AppSalaryGradesAndRangesSourceOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )
        st = generate_struct_type(survey_app_pb2.AppSalaryGradesAndRangesDomainOriented)
        print(
            f"AppSalaryGradesAndRangesDomainOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )
        st = generate_struct_type(
            survey_do_not_publish_pb2.SurveyDoNotPublishSourceOriented
        )
        print(
            f"SurveyDoNotPublishSourceOriented=StructType.fromJson(json.loads({json.dumps(st.json())}))"
        )

        # fd = survey_physician_pb2.PhysicianIncumbentSourceOriented.DESCRIPTOR.fields[49]
        # print(fd.message_type.full_name)
        # print(fd.message_type._concrete_class)
        # Access the FieldOptions for the field
        # field_options = fd.GetOptions()
        #
        # # List all the options and their values
        # for option_descriptor, value in field_options.ListFields():
        #     option_name = option_descriptor.name
        #     print(f"Option: {option_name}, Value: {value}")

        # fm = get_field_metadata(survey_physician_pb2.PhysicianIncumbentSourceOriented)
        # for f in fm:
        #     print()
        #     print(f)
        #     print()

        # st = generate_struct_type(survey_physician_pb2.PhysicianIncumbentSourceOriented).jsonValue()
        # print(json.dumps(st, indent=2))

        # fm = get_field_metadata(data_governance_framework_pb2.TableAudit)
        # for f in fm:
        #     print()
        #     print(f)
        #     print()
