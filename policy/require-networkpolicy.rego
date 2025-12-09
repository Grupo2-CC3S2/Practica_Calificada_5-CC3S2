package policy.networkpolicy
import rego.v1

deny contains msg if {
    # Cuenta cuántas policies hay
    policies := [doc | doc := input[_]; doc.kind == "NetworkPolicy"]
    count(policies) == 0
    msg := "No se encontró ninguna NetworkPolicy (Se requiere al menos una)"
}

exists_networkpolicy if {
  doc := input[_]
  doc.kind == "NetworkPolicy"
}
