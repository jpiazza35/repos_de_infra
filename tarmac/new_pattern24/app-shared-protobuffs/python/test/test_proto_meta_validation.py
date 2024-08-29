from unittest import TestCase

from cn.survey.app.v1 import survey_app_pb2
from cn.survey.physician.v1 import survey_physician_pb2
from cn_proto_utils.proto_meta_validation import (
    InvalidProtoMetadataException,
    verify_precision_and_scale,
)


class TestProtoMetaValidation(TestCase):
    def test_verify_precision_and_scale(self):
        has_errors = verify_precision_and_scale(
            survey_physician_pb2.PhysicianIncumbentSourceOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_physician_pb2.PhysicianIncumbentDomainOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_physician_pb2.PhysicianNewHireSourceOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_physician_pb2.PhysicianNewHireDomainOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_app_pb2.AppIncumbentSourceOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_app_pb2.AppIncumbentDomainOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_app_pb2.AppNewHireSourceOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_app_pb2.AppNewHireDomainOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_app_pb2.AppCallPaySourceOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_app_pb2.AppCallPayDomainOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_app_pb2.AppSalaryGradesAndRangesSourceOriented
        )
        has_errors = has_errors + verify_precision_and_scale(
            survey_app_pb2.AppSalaryGradesAndRangesDomainOriented
        )

        if has_errors:
            raise InvalidProtoMetadataException(
                "Invalid metadata in protobuf definition"
            )
