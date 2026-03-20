from flask import Flask, jsonify, request, render_template
import yaml
import os
import docker
from datetime import datetime

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ARL_CONFIG_PATH = os.environ.get('CONFIG_PATH', os.path.join(BASE_DIR, '..', 'config-docker.yaml'))

def load_config():
    with open(ARL_CONFIG_PATH, 'r', encoding='utf-8') as f:
        return yaml.safe_load(f)

def save_config(config):
    with open(ARL_CONFIG_PATH, 'w', encoding='utf-8') as f:
        yaml.dump(config, f, allow_unicode=True, default_flow_style=False)

def restart_arl_containers():
    try:
        client = docker.from_env()
        # 尝试多种可能的容器名称
        containers = [
            ('arl_web', 'ai_arl_web'),
            ('arl_worker', 'ai_arl_worker'),
            ('arl_scheduler', 'ai_arl_scheduler')
        ]
        for name, alt_name in containers:
            try:
                container = client.containers.get(name)
                container.restart()
                print(f"Restarted {name}")
            except Exception as e:
                print(f"Failed to restart {name}: {e}")
                try:
                    container = client.containers.get(alt_name)
                    container.restart()
                    print(f"Restarted {alt_name}")
                except Exception as e2:
                    print(f"Failed to restart {alt_name}: {e2}")
    except Exception as e:
        print(f"Docker not available: {e}")

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/api/config', methods=['GET'])
def get_config():
    try:
        config = load_config()
        return jsonify({'code': 200, 'message': 'success', 'data': config})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e), 'data': None})

@app.route('/api/config/fofa', methods=['PUT'])
def update_fofa():
    try:
        data = request.get_json()
        config = load_config()
        if 'email' in data:
            config['FOFA']['EMAIL'] = data['email']
        if 'key' in data:
            config['FOFA']['KEY'] = data['key']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': 'FOFA配置已更新', 'data': config['FOFA']})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/api_key', methods=['PUT'])
def update_api_key():
    try:
        data = request.get_json()
        config = load_config()
        if 'api_key' in data:
            config['ARL']['API_KEY'] = data['api_key']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': 'API_KEY已更新', 'data': {'API_KEY': config['ARL']['API_KEY']}})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/hunter', methods=['PUT'])
def update_hunter():
    try:
        data = request.get_json()
        config = load_config()
        if 'api_key' in data:
            config['QUERY_PLUGIN']['hunter_qax']['api_key'] = data['api_key']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': 'Hunter配置已更新', 'data': config['QUERY_PLUGIN']['hunter_qax']})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/quake', methods=['PUT'])
def update_quake():
    try:
        data = request.get_json()
        config = load_config()
        if 'quake_token' in data:
            config['QUERY_PLUGIN']['quake_360']['quake_token'] = data['quake_token']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': 'Quake配置已更新', 'data': config['QUERY_PLUGIN']['quake_360']})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/zoomeye', methods=['PUT'])
def update_zoomeye():
    try:
        data = request.get_json()
        config = load_config()
        if 'api_key' in data:
            config['QUERY_PLUGIN']['zoomeye']['api_key'] = data['api_key']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': 'ZoomEye配置已更新', 'data': config['QUERY_PLUGIN']['zoomeye']})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/github', methods=['PUT'])
def update_github():
    try:
        data = request.get_json()
        config = load_config()
        if 'token' in data:
            config['GITHUB']['TOKEN'] = data['token']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': 'GitHub Token已更新', 'data': {'TOKEN': config['GITHUB']['TOKEN']}})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/proxy', methods=['PUT'])
def update_proxy():
    try:
        data = request.get_json()
        config = load_config()
        if 'http_url' in data:
            config['PROXY']['HTTP_URL'] = data['http_url']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': '代理配置已更新', 'data': config['PROXY']})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/dingding', methods=['PUT'])
def update_dingding():
    try:
        data = request.get_json()
        config = load_config()
        if 'secret' in data:
            config['DINGDING']['SECRET'] = data['secret']
        if 'access_token' in data:
            config['DINGDING']['ACCESS_TOKEN'] = data['access_token']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': '钉钉配置已更新', 'data': config['DINGDING']})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/email', methods=['PUT'])
def update_email():
    try:
        data = request.get_json()
        config = load_config()
        if 'host' in data:
            config['EMAIL']['HOST'] = data['host']
        if 'port' in data:
            config['EMAIL']['PORT'] = data['port']
        if 'username' in data:
            config['EMAIL']['USERNAME'] = data['username']
        if 'password' in data:
            config['EMAIL']['PASSWORD'] = data['password']
        if 'to' in data:
            config['EMAIL']['TO'] = data['to']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': '邮件配置已更新', 'data': config['EMAIL']})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/config/blacklist', methods=['PUT'])
def update_blacklist():
    try:
        data = request.get_json()
        config = load_config()
        if 'black_ips' in data:
            config['ARL']['BLACK_IPS'] = data['black_ips']
        if 'forbidden_domains' in data:
            config['ARL']['FORBIDDEN_DOMAINS'] = data['forbidden_domains']
        save_config(config)
        restart_arl_containers()
        return jsonify({'code': 200, 'message': '安全配置已更新', 'data': {
            'BLACK_IPS': config['ARL']['BLACK_IPS'],
            'FORBIDDEN_DOMAINS': config['ARL']['FORBIDDEN_DOMAINS']
        }})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({'code': 200, 'message': 'healthy', 'time': datetime.now().isoformat()})

@app.route('/api/arl/restart', methods=['POST'])
def restart_arl():
    try:
        restart_arl_containers()
        return jsonify({'code': 200, 'message': 'ARL服务已重启'})
    except Exception as e:
        return jsonify({'code': 500, 'message': str(e)})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5005, debug=True)
