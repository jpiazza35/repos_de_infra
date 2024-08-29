from unittest import TestCase

from pyspark import Row

from simple_integration_service.integration_functions import pivot_by_col_name_pattern


class TestIntegrationFunctions(TestCase):
    def test_pivot_by_col_name_pattern(self):
        test_row = Row(Percentile_1=123.03, Percentile_2=124.34, Name='Somebody')
        result = pivot_by_col_name_pattern('Percentile_', test_row, True)
        self.assertIn('1', result)
        self.assertIn('2', result)
        self.assertNotIn('Name', result)
        self.assertNotIn('Percentile_2', result)

        test_row = Row(Percentile_1=123.03, Percentile_2=124.34, Name='Somebody')
        result = pivot_by_col_name_pattern('Percentile_', test_row, False)
        self.assertIn('Percentile_1', result)
        self.assertIn('Percentile_2', result)
        self.assertNotIn('Name', result)
        self.assertNotIn('1', result)


