import logging
import subprocess
import json
import base64

LOG_FORMAT = '%(asctime)s | %(levelname)7s | %(name)s | line:%(lineno)4s | %(message)s)'
logging.basicConfig(format=LOG_FORMAT, level=logging.DEBUG)


def run_command(cmd):
    process = subprocess.run(cmd, check=True, stdout=subprocess.PIPE, universal_newlines=True)
    return process.stdout


cluster_data = {"managedClusters": []}

oc_command = ['oc', 'get', 'managedclusters', '--selector', 'name!=local-cluster', '-o', 'json']
managed_clusters = json.loads(run_command(oc_command))

list_index = 0

for index, item in enumerate(managed_clusters['items']):
    cluster_status = "Unknown"
    try:
        for condition in item['status']['conditions']:
            if condition['type'] == 'ManagedClusterConditionAvailable':
                cluster_status = condition['status']
        if cluster_status == "True":
            logging.info(f"item --> {item}")
            logging.info(f"TYPE --> {item['metadata']['annotations']['open-cluster-management/created-via']}")
            # if item['metadata']['annotations']["open-cluster-management/created-via"] == "hive" or  item['metadata']['annotations']["open-cluster-management/created-via"] == "assisted-installer" or  item['metadata']['annotations']["open-cluster-management/created-via"] == "other":
            if item['metadata']['annotations']["open-cluster-management/created-via"] == "hive" or item['metadata']['annotations']["open-cluster-management/created-via"] == "assisted-installer" or item['metadata']['annotations']["open-cluster-management/created-via"] == "hypershift":
                cluster_data["managedClusters"].append({"name": item['metadata']['name']})
                try:
                    cluster_data["managedClusters"][list_index]["api_url"] = item['spec']['managedClusterClientConfigs'][0]['url']
                    cluster_data["managedClusters"][list_index]["base_domain"] = item['spec']['managedClusterClientConfigs'][0]['url'].replace("https://api.", "").split(":")[0]
                except Exception:
                    for kv_pair in item['status']['clusterClaims']:
                        if kv_pair['name'] == 'consoleurl.cluster.open-cluster-management.io':
                            cluster_data["managedClusters"][list_index]["console_url"] = kv_pair['value']
                            cluster_data["managedClusters"][list_index]["base_domain"] = kv_pair['value'].replace("https://console-openshift-console.apps.", "")
                            cluster_data["managedClusters"][list_index]["api_url"] = kv_pair['value'].replace("console-openshift-console.apps", "api") + ":6443"
                secret_command = ['oc', 'get', 'secrets', '--selector=hive.openshift.io/secret-type=kubeadmincreds', '-o', 'json', '-n']
                secret_command.append(item['metadata']['name'])
                secret_list = json.loads(run_command(secret_command))
                logging.info(f"secret_list --> {secret_list}")
                password = base64.b64decode(secret_list['items'][0]['data']['password']).decode('utf-8')
                username = base64.b64decode(secret_list['items'][0]['data']['username']).decode('utf-8')
                logging.info(f"username --> {username}")
                cluster_data["managedClusters"][list_index]["username"] = username
                cluster_data["managedClusters"][list_index]["password"] = password
                list_index += 1
    except Exception:
        list_index += 1
with open('managedClusters.json', 'w') as f:
    json.dump(cluster_data, f)
