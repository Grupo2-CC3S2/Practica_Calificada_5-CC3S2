package policy.networkpolicy

deny[msg] {
  count(networkpolicies) == 0
  msg = "No existe ninguna NetworkPolicy en los manifests"
}

networkpolicies[np] {
  np := input[_]
  np.kind == "NetworkPolicy"
}
