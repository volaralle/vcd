vms = [
    {
        name = "vm-01"
        cpu = 2
        ram = 2048
        cores = 2
        hdd = 41200
        roles   =   "balancer, kafka, minio, rabbitmq, elastic_search, birt"
    },
    {
        name = "vm-02"
        cpu = 2
        ram = 2048
        cores = 2
        hdd = 82400
        roles   =   "postgres, pgagent, redis"
    }
]
