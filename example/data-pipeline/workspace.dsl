workspace {

    !identifiers hierarchical

    model {
        user = person "User"

        softwareSystem = softwareSystem "Audio Pipeline"{

            datasource = container "Audio Input" {
                tags "Data Connector"
            }

            service1 = group "Audio Speech Recognition" {
                service1aApi = container "Voice activity detection (VAD)" "Detection of the presence or absence of human speech" {
                    tags "Service 1" "Component"
                }

                service1bApi = container "Speech enhancement (SE)" "" {
                    tags "Service 1" "Component"
                    service1aApi -> this ""
                }

                service1cApi = container "Diarization" "Partitioning an audio stream containing human speech into homogeneous segments according to the identity of each speaker" {
                    tags "Service 1" "Component"
                    service1bApi -> this ""
                }

                service1dApi = container "Language Identification (LID)" "Identification of spoken language" {
                    tags "Service 1" "Component"
                    service1cApi -> this ""
                }

                service1eApi = container "Speech Separation" "" {
                    tags "Service 1" "Component"
                    service1dApi -> this ""
                }

                service1fApi = container "Code Switch" "" {
                    tags "Service 1" "Component"
                    service1eApi -> this ""
                }
            }

            service2 = group "Speech Application" {
                service2aApi = container "Speaker Identification" "Identification of speaker" {
                    tags "Service 2" "Component"
                }
                
                service2bApi = container "Keyword Spotting" "" {
                    tags "Service 2" "Component"
                    service2aApi -> this ""
                }

                service2cApi = container "Speech To Text (STT)" "" {
                    tags "Service 2" "Component"
                    service2bApi -> this ""
                }

                service2dApi = container "Machine Translation" "" {
                    tags "Service 2" "Component"
                    service2cApi -> this ""
                }
            }

            service3 = group "Monitoring" {
                service3aApi = container "Out-of-vocabulary (OOV)" {
                    tags "Service 3" "Component"
                }

                service3bApi = container "Context Change" {
                    tags "Service 3" "Component"
                    service3aApi -> this ""
                }

                service3cApi = container "Acoustic Mismatch" {
                    tags "Service 3" "Component"
                    service3bApi -> this ""
                }
            }

            service4 = group "Retraining" {
                service4aApi = container "Data Cartography" {
                    tags "Service 4" "Component"
                }
                service4bApi = container "Performance Verification" {
                    tags "Service 4" "Component"
                    service4aApi -> this ""
                }
            }

            service5 = group "Model Repository" {
                service5Api = container "Model Registry" {
                    tags "Service 5" "Database" "Data Connector"
                }
            }

            service6 = group "Storage" {
                service6Api = container "Data Storage" {
                    tags "Service 6" "Database" "Data Connector"
                }
            }

            user -> datasource
            datasource -> service1aApi
            service1fApi -> service2aApi
            service1fApi -> service6Api
            service2dApi -> service3aApi
            service2dApi -> service6Api
            service3cApi -> service4aApi
            service4bApi -> service5Api "Writes to"
            service5Api -> service2aApi "Reads from"
        }

    }

    views {
        container softwareSystem "Containers_All" {
            include *
            autolayout lr
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

        container softwareSystem "Containers_Service4" {
            include ->softwareSystem.service4->
            autolayout
        }

        container softwareSystem "Containers_Service5" {
            include ->softwareSystem.service4->
            autolayout
        }

        container softwareSystem "Containers_Service6" {
            include ->softwareSystem.service4->
            autolayout
        }

        styles {
            element "Person" {
                shape Person
            }
            element "Data Connector" {
                shape hexagon
            }
            element "Database" {
                shape cylinder
            }
            element "Service 1" {
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

        }

    }

}
