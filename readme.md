# CI-SonarQube-Metrics-Dashboard

This project sets up a dashboard to visualize SonarQube metrics using Prometheus, Grafana, and Jenkins. It provides a clear and interactive way to monitor code quality metrics from your CI/CD pipeline.

![How looks the resulted Dashboard](./img/dashboard-result.png)

## Features

- **SonarQube Integration**: Fetches code quality metrics.
- **Prometheus Monitoring**: Scrapes metrics from SonarQube.
- **Grafana Visualization**: Displays metrics in an interactive dashboard.
- **Jenkins Automation**: Integrates with Jenkins for automated updates.

## Getting Started

### Prerequisites

- docker-compose
- modify the .env values

### Installation

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/CI-SonarQube-Metrics-Dashboard.git
   cd CI-SonarQube-Metrics-Dashboard

2. **Run the start-service script**

    ```bash
    ./start-service.sh