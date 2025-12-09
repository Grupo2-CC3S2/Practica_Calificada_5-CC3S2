package policy.networkpolicy

deny[msg] {
  # Solo aplica a resources dentro del mismo namespace evaluado
  input.kind != "NetworkPolicy"

  # Si no existe ningún NetworkPolicy en el bundle evaluado
  not some np
  np := data.resources[_]
  np.kind == "NetworkPolicy"

  msg = "No existe NetworkPolicy: cada namespace debe tener al menos una"
}
