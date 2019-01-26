module Group

%access public export

||| Given a type and a binary operation the type of proofs that the operation is associative
total
Associative : (typ : Type) -> ((*): typ -> typ -> typ) -> Type
Associative typ (*) = (a : typ) -> (b : typ) -> (c : typ) -> ((a * b) * c) = (a * (b * c))

||| Given a type and a binary operation the type of proofs that the operation is commutative
total
Commutative : (typ : Type) -> ((*) : typ -> typ -> typ) -> Type
Commutative typ (*) = (a : typ) -> (b : typ) -> (a * b) = (b * a)

||| Given a type and a binary operation the type of proofs that identity exists
total
IdentityExists : (typ : Type) -> ((*) : typ -> typ -> typ) -> Type
IdentityExists typ (*) = (e : typ ** (a : typ ** ((a*e) = a, (e*a) = a)))

||| Given a type and a binary operation the type of proofs that each element has its inverse
total
InverseExists : (typ : Type) -> ((*) : typ -> typ -> typ) -> Type
InverseExists typ (*) = (pfid : (IdentityExists typ (*)) ** ((a : typ) -> (a_inv : typ ** ((a*a_inv = fst(pfid)),(a_inv*a = fst(pfid))))))

--||| Given a type and a binary operation the type of proofs that the type along with the
||| operation is a group
total
IsGroup : (grp : Type) -> ((*) : grp -> grp -> grp) -> Type
IsGroup grp (*) = (Associative grp (*), (IdentityExists grp (*), InverseExists grp (*)))

-- Generates inverses
Inv: (grp : Type) -> ((*) : grp -> grp -> grp) -> IsGroup grp (*) -> (x: grp) -> grp
Inv grp (*) y x = fst(snd(snd(snd(y))) x)

-- Given a group, the type of proofs that it is abelian
total
IsAbelian:  (grp : Type) -> ((*) : grp -> grp -> grp) -> IsGroup grp (*) -> Type
IsAbelian grp (*) x = (a:grp) -> (b:grp) -> (a*b = b*a)

-- The type of proofs that a given function f between x and y is injective
total
Inj: (x: Type) -> (y: Type) -> (f: x-> y) -> Type
Inj x y f = ((a: x) -> (b: x) -> (f a = f b) -> a = b)

-- The type of proofs that a function between groups is a homomorphism
total
Hom: (grp : Type) -> ((*) : grp -> grp -> grp) -> (g : Type) -> ((***) : g -> g -> g) -> (f: grp -> g) -> Type
Hom grp (*) g (+) f = (a: grp) -> (b: grp) -> ((f (a*b)) = ((f a)+(f b)))

-- The type of proofs that a given group is a subgroup of another, via injective homorphisms
total
Subgroup: (h: Type) -> ((+) : h -> h -> h) -> (IsGroup h (+)) -> (g: Type) -> ((*) : g -> g -> g) -> (IsGroup g (*)) -> Type
Subgroup h (+) x g (*) y = DPair (h->g) (\f => ((Hom h (+) g (*) f), (Inj h g f)))

-- The type of proofs that a given subgroup is self-conjugate
total
NSub: (h: Type) -> ((+) : h -> h -> h) -> (x: IsGroup h (+)) -> (g: Type) -> ((*) : g -> g -> g) -> (y: IsGroup g (*)) -> (Subgroup h (+) x g (*) y) -> Type
NSub h (+) x g (*) y z = (a: h) -> (b: g) -> (x: h ** (b*(f a)*(inv b) = (f x))) where
  f = fst(z)
  inv = Inv g (*) y
