package policy.networkpolicy

# Extrae todos los resources cargados por Conftest
resources := [r | r := input]

deny[msg] {
  count(networkpolicies) == 0
  msg = "No existe NetworkPolicy: cada namespace debe tener al menos una"
}

networkpolicies[r] {
  r := resources[_]
  r.kind == "NetworkPolicy"
}
