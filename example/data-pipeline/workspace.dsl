workspace {

    !identifiers hierarchical

    model {
        user = person "User"

        softwareSystem = softwareSystem "Audio Pipeline"{

            webapp = container "Audio Input" {
                tags "Data Connector"
            }

            service1 = group "Audio Speech Recognition" {
                service1aApi = container "Voice activity detection (VAD)" "Detection of the presence or absence of human speech" {
                    tags "Service 1" "Component"
                }
                service1bApi = container "Diarization" "Partitioning an audio stream containing human speech into homogeneous segments according to the identity of each speaker" {
                    tags "Service 1" "Component"
                    service1aApi -> this "Reads from and writes to"
                }

                service1cApi = container "Language Identification (LID)" "Identification of spoken language" {
                    tags "Service 1" "Component"
                    service1bApi -> this "Reads from and writes to"
                }
            }

            service2 = group "Speech Application" {
                service2Api = container "speaker identification" "Identification of speaker" {
                    tags "Service 2" "Component"
                }
            }

            service3 = group "Monitoring" {
                service3Api = container "Out-of-vocabulary (OOV)" {
                    tags "Service 3" "Component"
                }
            }

            service4 = group "Service 4" {
                service4Api = container "Service 4 API" {
                    tags "Service 4" "Service API"
                }
                container "Service 4 Database" {
                    tags "Service 4" "Database"
                    service4Api -> this "Reads from and writes to"
                }
            }

            service5 = group "Service 5" {
                service5Api = container "Service 5 API" {
                    tags "Service 5" "Service API"
                }
                container "Service 5 Database" {
                    tags "Service 5" "Database"
                    service5Api -> this "Reads from and writes to"
                }
            }

            service6 = group "Service 6" {
                service6Api = container "Service 6 API" {
                    tags "Service 6" "Service API"
                }
                container "Service 6 Database" {
                    tags "Service 6" "Database"
                    service6Api -> this "Reads from and writes to"
                }
            }

            service7 = group "Service 7" {
                service7Api = container "Service 7 API" {
                    tags "Service 7" "Service API"
                }
                container "Service 7 Database" {
                    tags "Service 7" "Database"
                    service7Api -> this "Reads from and writes to"
                }
            }

            service8 = group "Service 8" {
                service8Api = container "Service 8 API" {
                    tags "Service 8" "Service API"
                }
                container "Service 8 Database" {
                    tags "Service 8" "Database"
                    service8Api -> this "Reads from and writes to"
                }
            }

            user -> webapp
            webapp -> service1aApi
            service1cApi -> service2Api
            service1cApi -> service3Api
            service2Api -> service3Api
            service2Api -> service5Api
            webapp -> service3Api
            service3Api -> service4Api
            service3Api -> service7Api
            service4Api -> service6Api
            service7Api -> service8Api
        }

    }

    views {
        container softwareSystem "Containers_All" {
            include *
            autolayout
        }

        container softwareSystem "Containers_Service1" {
            include ->softwareSystem.service1->
            autolayout
        }

        container softwareSystem "Containers_Service2" {
            include ->softwareSystem.service2->
            autolayout
        }

        container softwareSystem "Containers_Service3" {
            include ->softwareSystem.service3->
            autolayout
        }

        styles {
            element "Person" {
                shape Person
            }
            element "Service API 1" {
                shape hexagon
            }
            element "Database" {
                shape cylinder
            }
            element "Audio Speech Recognition" {
                background #91F0AE
            }
            element "Service 2" {
                background #EDF08C
            }
            element "Service 3" {
                background #8CD0F0
            }
            element "Service 4" {
                background #F08CA4
            }
            element "Service 5" {
                background #FFAC33
            }
            element "Service 6" {
                background #DD8BFE
            }
            element "Service 7" {
                background #89ACFF
            }
            element "Service 8" {
                background #FDA9F4
            }

        }

    }

}
