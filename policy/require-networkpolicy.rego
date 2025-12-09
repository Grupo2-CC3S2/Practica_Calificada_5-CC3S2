package policy.networkpolicy

# Denegar si NO existe ninguna NetworkPolicy
deny[msg] if {
  not exists_networkpolicy
  msg := "No existe ninguna NetworkPolicy en los manifests"
}

# Función auxiliar
exists_networkpolicy if {
  some doc
  doc := input[_]
  doc.kind == "NetworkPolicy"
}
