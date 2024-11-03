from unittest import TestCase

from callability_server import main


class TestCommandLineInterface(TestCase):
    def test_cli(self):
        with self.assertRaises(SystemExit):
            main.cli()
