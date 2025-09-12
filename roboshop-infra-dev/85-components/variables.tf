variable "components" {
    default = {
        
        payment = {
            rule_priority = 50
        }
        frontend = {
            rule_priority = 10
        }
        
    }
}