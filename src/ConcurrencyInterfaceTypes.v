(* Concurrency interface base types, as generated by Sail.*)
Require Import Sail.Real.
Require Import Sail.Base.
Import ListNotations.
Open Scope string.
Open Scope bool.
Open Scope Z.

Inductive Access_variety := AV_plain | AV_exclusive | AV_atomic_rmw.
Scheme Equality for Access_variety.
#[export] Instance Decidable_eq_Access_variety :
forall (x y : Access_variety), Decidable (x = y) :=
Decidable_eq_from_dec Access_variety_eq_dec.
#[export] Instance dummy_Access_variety : Inhabited Access_variety := { inhabitant := AV_plain }.


Inductive Access_strength := AS_normal | AS_rel_or_acq | AS_acq_rcpc.
Scheme Equality for Access_strength.
#[export] Instance Decidable_eq_Access_strength :
forall (x y : Access_strength), Decidable (x = y) :=
Decidable_eq_from_dec Access_strength_eq_dec.
#[export] Instance dummy_Access_strength : Inhabited Access_strength := { inhabitant := AS_normal }.


Record Explicit_access_kind :=
{
  Explicit_access_kind_variety : Access_variety;
  Explicit_access_kind_strength : Access_strength;
}.
Arguments Explicit_access_kind : clear implicits.
Notation "{[ r 'with' 'Explicit_access_kind_variety' := e ]}" :=
  match r with Build_Explicit_access_kind _ f1 => Build_Explicit_access_kind e f1 end.
Notation "{[ r 'with' 'Explicit_access_kind_strength' := e ]}" :=
  match r with Build_Explicit_access_kind f0 _ => Build_Explicit_access_kind f0 e end.
#[export]
Instance dummy_Explicit_access_kind :
  Inhabited (Explicit_access_kind ) :=
{
  inhabitant := {|
    Explicit_access_kind_variety := inhabitant;
    Explicit_access_kind_strength := inhabitant
|} }.


Inductive Access_kind {arch_ak : Type} :=
| AK_explicit : Explicit_access_kind -> Access_kind
| AK_ifetch : unit -> Access_kind
| AK_ttw : unit -> Access_kind
| AK_arch : arch_ak -> Access_kind.
Arguments Access_kind : clear implicits.

#[export]
Instance dummy_Access_kind {arch_ak : Type} `{Inhabited arch_ak} :
  Inhabited (Access_kind arch_ak) :=
{
  inhabitant := AK_explicit inhabitant
}.

Record Mem_read_request {n : Z} {vasize : Z} {pa : Type} {ts : Type} {arch_ak : Type} (*n >? 0*) :=
{
  Mem_read_request_access_kind : Access_kind arch_ak;
  Mem_read_request_va : option (mword vasize);
  Mem_read_request_pa : pa;
  Mem_read_request_translation : ts;
  Mem_read_request_size : Z;
  Mem_read_request_tag : bool;
}.
Arguments Mem_read_request : clear implicits.
Notation "{[ r 'with' 'Mem_read_request_access_kind' := e ]}" :=
  match r with Build_Mem_read_request _ _ _ _ _ _ f1 f2 f3 f4 f5 =>
    Build_Mem_read_request _ _ _ _ _ e f1 f2 f3 f4 f5 end.
Notation "{[ r 'with' 'Mem_read_request_va' := e ]}" :=
  match r with Build_Mem_read_request _ _ _ _ _ f0 _ f2 f3 f4 f5 =>
    Build_Mem_read_request _ _ _ _ _ f0 e f2 f3 f4 f5 end.
Notation "{[ r 'with' 'Mem_read_request_pa' := e ]}" :=
  match r with Build_Mem_read_request _ _ _ _ _ f0 f1 _ f3 f4 f5 =>
    Build_Mem_read_request _ _ _ _ _ f0 f1 e f3 f4 f5 end.
Notation "{[ r 'with' 'Mem_read_request_translation' := e ]}" :=
  match r with Build_Mem_read_request _ _ _ _ _ f0 f1 f2 _ f4 f5 =>
    Build_Mem_read_request _ _ _ _ _ f0 f1 f2 e f4 f5 end.
Notation "{[ r 'with' 'Mem_read_request_size' := e ]}" :=
  match r with Build_Mem_read_request _ _ _ _ _ f0 f1 f2 f3 _ f5 =>
    Build_Mem_read_request _ _ _ _ _ f0 f1 f2 f3 e f5 end.
Notation "{[ r 'with' 'Mem_read_request_tag' := e ]}" :=
  match r with Build_Mem_read_request _ _ _ _ _ f0 f1 f2 f3 f4 _ =>
    Build_Mem_read_request _ _ _ _ _ f0 f1 f2 f3 f4 e end.
#[export]
Instance dummy_Mem_read_request {n : Z} {vasize : Z} {pa : Type} {ts : Type} {arch_ak : Type}
  (*n >? 0*) `{Inhabited pa} `{Inhabited ts} `{Inhabited arch_ak} :
  Inhabited (Mem_read_request n vasize pa ts arch_ak) :=
{
  inhabitant := {|
    Mem_read_request_access_kind := inhabitant;
    Mem_read_request_va := inhabitant;
    Mem_read_request_pa := inhabitant;
    Mem_read_request_translation := inhabitant;
    Mem_read_request_size := inhabitant;
    Mem_read_request_tag := inhabitant
|} }.


Record Mem_write_request {n : Z} {vasize : Z} {pa : Type} {ts : Type} {arch_ak : Type} (*n >? 0*) :=
{
  Mem_write_request_access_kind : Access_kind arch_ak;
  Mem_write_request_va : option (mword vasize);
  Mem_write_request_pa : pa;
  Mem_write_request_translation : ts;
  Mem_write_request_size : Z;
  Mem_write_request_value : option (mword (8 * n));
  Mem_write_request_tag : option bool;
}.
Arguments Mem_write_request : clear implicits.
Arguments Build_Mem_write_request &.
Notation "{[ r 'with' 'Mem_write_request_access_kind' := e ]}" :=
  match r with Build_Mem_write_request _ _ _ _ _ _ f1 f2 f3 f4 f5 f6 =>
    Build_Mem_write_request _ _ _ _ _ e f1 f2 f3 f4 f5 f6 end.
Notation "{[ r 'with' 'Mem_write_request_va' := e ]}" :=
  match r with Build_Mem_write_request _ _ _ _ _ f0 _ f2 f3 f4 f5 f6 =>
    Build_Mem_write_request _ _ _ _ _ f0 e f2 f3 f4 f5 f6 end.
Notation "{[ r 'with' 'Mem_write_request_pa' := e ]}" :=
  match r with Build_Mem_write_request _ _ _ _ _ f0 f1 _ f3 f4 f5 f6 =>
    Build_Mem_write_request _ _ _ _ _ f0 f1 e f3 f4 f5 f6 end.
Notation "{[ r 'with' 'Mem_write_request_translation' := e ]}" :=
  match r with Build_Mem_write_request _ _ _ _ _ f0 f1 f2 _ f4 f5 f6 =>
    Build_Mem_write_request _ _ _ _ _ f0 f1 f2 e f4 f5 f6 end.
Notation "{[ r 'with' 'Mem_write_request_size' := e ]}" :=
  match r with Build_Mem_write_request _ _ _ _ _ f0 f1 f2 f3 _ f5 f6 =>
    Build_Mem_write_request _ _ _ _ _ f0 f1 f2 f3 e f5 f6 end.
Notation "{[ r 'with' 'Mem_write_request_value' := e ]}" :=
  match r with Build_Mem_write_request _ _ _ _ _ f0 f1 f2 f3 f4 _ f6 =>
    Build_Mem_write_request _ _ _ _ _ f0 f1 f2 f3 f4 e f6 end.
Notation "{[ r 'with' 'Mem_write_request_tag' := e ]}" :=
  match r with Build_Mem_write_request _ _ _ _ _ f0 f1 f2 f3 f4 f5 _ =>
    Build_Mem_write_request _ _ _ _ _ f0 f1 f2 f3 f4 f5 e end.
#[export]
Instance dummy_Mem_write_request {n : Z} {vasize : Z} {pa : Type} {ts : Type} {arch_ak : Type}
  (*n >? 0*) `{Inhabited pa} `{Inhabited ts} `{Inhabited arch_ak} :
  Inhabited (Mem_write_request n vasize pa ts arch_ak) :=
{
  inhabitant := {|
    Mem_write_request_access_kind := inhabitant;
    Mem_write_request_va := inhabitant;
    Mem_write_request_pa := inhabitant;
    Mem_write_request_translation := inhabitant;
    Mem_write_request_size := inhabitant;
    Mem_write_request_value := inhabitant;
    Mem_write_request_tag := inhabitant
|} }.



