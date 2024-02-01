#using https://structurizr.com/dsl
workspace "GAIA-Workspace" {

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        user = person "User" "" "User"

        gaiaSystem = softwareSystem "GAIA" {
            haproxy = container "HAProxy" {
                description "Reverse Proxy"
                tags "HAProxy" "HAProxy 2.4.22"
            }
            frontend = container "React Frontend" {
                description "Static Frontend"
                tags "Nginx" "Web Browser" "Node 18.18.2" "Nginx 1.25.3"
            }
            backend = container "Node Backend" {
                description "Backend Web Application"
                tags "Node" "Node 18.18.2"
            }
                pdfParser = container "PDF Parser" {
                description "PDF Parser"
                tags "Python" "Python 3.8.16"
            }
            semanticsManager = container "Semantics Manager" {
                description "Weaviate Python Client"
                tags "Python" "Python 3.8.16" "sentence-transformers/all-mpnet-base-v2"
            }
            mongodb = container "MongoDB"  {
                description "NoSQL database. Stores context documents, inference logs, feedback and latest chat"
                tags "MongoDB" "Database" "MongoDB 6.0.5"
            }
            scylladb = container "ScyllaDB"  {
                description "NoSQL wide-column data store. Stores chat history"
                tags "ScyllaDB" "Database" "ScyllaDB 5.2"
            }
            weaviate = container "Weaviate"  {
                description "Vector Database. Stores vector embeddings"
                tags "Weaviate" "Database" "Weaviate 1.22.5"
            }
            vllm = container "vLLM" {
                description "Library for LLM inference and serving"
                tags "Python" "Python 3.8.16" "meta-llama/Llama-2-13b"
            }

            monitoringGroup = group "Monitoring Compontents" {
                prometheus = container "Prometheus" {
                    description "Open-source systems monitoring and alerting toolkit"
                    tags "Prometheus" "Prometheus 2.48.0"
                }
                grafana = container "Grafana" {
                    description "Open-source platform for data visualization and monitoring"
                    tags "Grafana" "Web Browser" "Grafana 10.2.2"
                }
                loki = container "Loki" {
                    description "Log aggregation system"
                    tags "Loki" "Loki 2.9.2"
                }
            }
            logsCollector = group "Logs Collector" {
                cadvisor = container "cAdvisor" {
                    description "Open-source tool to monitor containers"
                    tags "Red Hat Universal Base Image" "Red Hat Universal Base Image 8 (ubi8)" "CAdvisor 0.47.2"
                }
                nodeExporter = container "Node exporter" {
                    description "Prometheus exporter for hardware and OS metrics"
                    tags "Node-exporter" "Node-exporter 1.7.0"
                }
                promtail = container "Promtail" {
                    description "Collect and ship log data to Loki"
                    tags "Promtail" "Promtail 2.9.2"
                }
            }
        }

        # relationships between people and software systems
        user -> gaiaSystem "Provide texts or documents, and ask any question about the data"

        # relationships to/from containers
        user -> haproxy "Visits GAIA using" "HTTPS"
        haproxy -> frontend "Send to and receive from" "JSON/HTTP"
        frontend -> backend "Send to and receive from" "JSON/HTTP"
        backend -> pdfParser "Send to and receive from" "JSON/HTTP"
        backend -> mongodb "Reads from and writes to" "JSON/HTTP"
        backend -> scylladb "Reads from and writes to" "JSON/HTTP"
        backend -> semanticsManager "Send to and receive from" "JSON/HTTP"
        semanticsManager -> weaviate "Reads from and writes to" "JSON/HTTP"
        backend -> vllm "Send to and receive from" "JSON/HTTP"

        nodeExporter ->  prometheus "Collect and ship metrics to" "JSON/HTTP"
        promtail -> loki "Collect and ship logs to" "JSON/HTTP"

        cadvisor -> grafana "Fetches from" "JSON/HTTP"
        prometheus -> grafana "Fetches from" "JSON/HTTP"
        loki -> grafana "Fetches from" "JSON/HTTP"

        systemDiagram = deploymentEnvironment "System Diagram" {
            deploymentNode "Production Zone" {
                client = infrastructureNode "Client"
                gaiaScope = group "GAIA Scope" {
                    gaiaGPU = infrastructureNode "GPU Machine" {
                        tags "Physical"
                    }
                    group "Audit Scope" {
                        gaiaVM1 = infrastructureNode "Web App VM" {
                            tags "Virtual Machine"
                        }
                        gaiaVM2 = infrastructureNode "Backend VM" {
                            tags "Virtual Machine"
                        }
                        gaiaVM3 = infrastructureNode "Database VM" {
                            tags "Virtual Machine"
                        }
                        gaiaVM1 -> gaiaVM2
                        gaiaVM2 -> gaiaVM3
                    }
                    gaiaVM2 -> gaiaGPU
                }
                client -> gaiaVM1
            }
        }

        networkDiagram = deploymentEnvironment "Network Diagram" {
            deploymentNode "Production Zone" {
                physicalSwitch = infrastructureNode "Switch" {
                    tags "Physical"
                }
                group "GAIA Network" {
                    vm1 = infrastructureNode "Web App VM" {
                        tags "Virtual Machine"
                    }
                    vm2 = infrastructureNode "Backend VM" {
                        tags "Virtual Machine"
                    }
                    vm3 = infrastructureNode "Database VM" {
                        tags "Virtual Machine"
                    }
                    gpuMachine = infrastructureNode "GPU Machine" {
                        tags "Physical Machine"
                    }
                }

                group "Maintenance Network" {
                    vm4 = infrastructureNode "Patch VM" {
                        tags "Virtual Machine"
                    }
                }
                vm1 -> physicalSwitch
                vm2 -> physicalSwitch
                vm3 -> physicalSwitch
                gpuMachine -> physicalSwitch
                vm4 -> physicalSwitch
            }
        }

        production = deploymentEnvironment "On Prem" {
            deploymentNode "On-Premise Data Center" {
                reverseProxy = infrastructureNode "F5 Reverse Proxy" {
                    tags "Physical"
                }
                deploymentNode "Zone 1" {
                    deploymentNode "Web Tier" {
                        deploymentNode "Virtual Machine" {
                            deploymentNode "Ubuntu Server" {
                                haproxyContainer = containerInstance haproxy
                                containerInstance frontend
                                webLogCollector = group "Log Collector" {
                                    containerInstance cadvisor
                                    containerInstance nodeExporter
                                    containerInstance promtail
                                }
                            }
                        }
                    }

                    deploymentNode "Business Tier" {
                        deploymentNode "Virtual Machine" {
                            deploymentNode "Ubuntu Server" {
                                containerInstance backend
                                backend2 = containerInstance backend
                                backend3 = containerInstance backend
                                containerInstance semanticsManager
                                group "Monitoring" {
                                    containerInstance prometheus
                                    containerInstance grafana
                                    containerInstance loki
                                }
                                group "Log Collector" {
                                    containerInstance cadvisor
                                    containerInstance nodeExporter
                                    containerInstance promtail
                                }
                            }
                        }
                        deploymentNode "GPU Machine" {
                            deploymentNode "Ubuntu Server" {
                                containerInstance vllm
                            }
                        }
                    }

                    deploymentNode "Database Tier" {
                        deploymentNode "Virtual Machine" {
                            deploymentNode "Ubuntu Server" {
                                containerInstance mongodb
                                containerInstance scylladb
                                containerInstance weaviate
                                databaseLogCollector = group "Log Collector" {
                                    containerInstance cadvisor
                                    containerInstance nodeExporter
                                    containerInstance promtail
                                }
                            }
                        }
                    }
                }
            }
            reverseProxy -> haproxyContainer "Forward requests to" "HTTPS"
        }
    }

    views {
        systemLandscape techStack {
            include *
            autoLayout
        }

        systemcontext gaiaSystem {
            include *
            autoLayout
        }
        container gaiaSystem {
            include *
            autoLayout
        }
        deployment gaiaSystem production {
            include *
            exclude webLogCollector->*
            exclude databaseLogCollector->*
            exclude backend2
            exclude backend3
            autoLayout
        }
        deployment gaiaSystem networkDiagram {
            include *
            autoLayout
        }
        deployment gaiaSystem systemDiagram {
            include *
            autoLayout
        }
        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                shape Person
            }
            element "User" {
                background #08427b
            }
            element "GAIA" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
                
            }
            element "Database" {
                shape Cylinder
            }
            element "Web Browser" {
                shape WebBrowser
            }
            element "Virtual Machine" {
                color #000000
                background #3c7ebf
            }
            element "Physical Machine" {
                color #000000
                background #a1c6ea
            }
            element "Physical" {
                color #000000
            }
            element "Group:GAIA Scope" {
                color #000000
                background #00ff00
                strokeWidth 3
            }
            element "Group:GAIA Scope/Audit Scope" {
                color #000000
                background #cc0000
                strokeWidth 3
            }
        }
    }
}
