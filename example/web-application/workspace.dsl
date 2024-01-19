workspace {

    model {
        u = person "User"

        s = softwareSystem "Software System" {
            haproxy = container "HAProxy" "" "HAProxy"
            frontend = container "React Frontend" "" "Nginx"
            backend = container "Node Backend" "" "Node"
            pdfParser = container "PDF Parser" "" "Python3.8"
            semanticsManager = container "Semantics Manager" "" "Python3.8"
            database = container "Database" "" "Relational database schema"
        }

        u -> frontend "Uses"
        frontend -> backend "Send to and receive from"
        backend -> pdfParser "Upload PDF"
        pdfParser -> database "Writes to"
        backend -> database "Reads from and writes to"

        live = deploymentEnvironment "On Prem" {

            deploymentNode "Amazon Web Services" {
                reverseProxy = infrastructureNode "F5 Reverse Proxy"

                deploymentNode "Zone 1" {
                    deploymentNode "Web Tier" {
                        deploymentNode "Virtual Machine" {
                            deploymentNode "Ubuntu Server" {
                                haproxyContainer = containerInstance haproxy
                                frontendContainer = containerInstance frontend
                            }
                        }
                    }

                    deploymentNode "Business Tier" {
                        deploymentNode "Virtual Machine" {
                            deploymentNode "Ubuntu Server" {
                                backend1Container = containerInstance backend
                                backend2Container = containerInstance backend
                                backend3Container = containerInstance backend
                            }
                        }
                    }



                    deploymentNode "Amazon RDS" {
                        deploymentNode "MySQL" {
                            containerInstance database
                        }
                    }
                }
            }

            reverseProxy -> haproxyContainer "Forward requests to" "HTTPS"

        }
    }

    views {
        container s {
            include *
            autoLayout
        }
        deployment s live {
            include *
            autoLayout
        }
    }

}
