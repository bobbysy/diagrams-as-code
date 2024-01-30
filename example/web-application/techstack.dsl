#using https://structurizr.com/dsl
workspace "GAIA-Techstack" {

    model {
        properties {
            "structurizr.groupSeparator" "/"
        }
        user = person "User" "" "User"

        techStack = softwareSystem "TechStack" {
            container "Frontend" {
                component "React"
            }
            group "Backend" {
                group "Services" {
                    container "Node" {
                        technology "Node 18.18.2"
                    }
                    container "PDF Parser"
                    container "Semantics Manager"
                }

                group "Database" {
                    container "MongoDB"
                    container "ScyllaDB"
                    container "Weaviate"
                }
            }
        }
    }

    views {
        systemcontext techStack {
            include *
            autoLayout
        }
        container techStack {
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
                metadata true
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
