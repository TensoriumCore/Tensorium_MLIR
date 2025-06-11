// RUN: relativity-opt %s --test-relativity-opt > %t
// RUN: FileCheck %s < %t

func.func @test_deriv_commute() {
  %g = relativity.tensor "g" : !relativity.tensor
  %d0 = relativity.cov_deriv %g, 0 : !relativity.tensor -> !relativity.tensor
  %d1 = relativity.cov_deriv %d0, 1 : !relativity.tensor -> !relativity.tensor

  // TODO: Ajouter des vérifications
  // CHECK: relativity.tensor
  return
}
