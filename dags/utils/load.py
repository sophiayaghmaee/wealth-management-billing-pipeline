import json
import os
import requests


class loadAccounts:
    url = "https://gist.githubusercontent.com/sophiayaghmaee/eb9c8db84d2b9476013fac8ef85a0dbf/raw"

    def get_account_data(self):
        output = requests.get(self.url)
        return json.dumps(output.json())


class loadSecurities:
    folder = "/opt/airflow/dags/data/securities"

    def list_files(self):
        return [
            {"filepath": f"{self.folder}/{file}"} for file in os.listdir(self.folder)
        ]
