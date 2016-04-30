open Errors
open Pp
open Util
open Names
open Term
open Decl_kinds
open Libobject
open Globnames
open Proofview.Notations

(** Utilities *)

(* let translate_name id = *)
(*   let id = Id.to_string id in *)
(*   Id.of_string (id ^ "ᶠ") *)

(* (\** Record of translation between globals *\) *)

	       
(* let translator : FTranslate.translator ref = *)
(*   Summary.ref ~name:"Forcing Global Table" Refmap.empty *)

(* type translator_obj = (global_reference * global_reference) list *)

(* let add_translator translator l = *)
(*   List.fold_left (fun accu (src, dst) -> Refmap.add src dst accu) translator l *)
							    
(* let cache_translator (_, l) = *)
(*   translator := add_translator !translator l *)

(* let load_translator _ l = cache_translator l *)
(* let open_translator _ l = cache_translator l *)
(* let subst_translator (subst, l) = *)
(*   let map (src, dst) = (subst_global_reference subst src, subst_global_reference subst dst) in *)
(*   List.map map l *)

(* let in_translator : translator_obj -> obj = *)
(*   declare_object { (default_object "FORCING TRANSLATOR") with *)
(*     cache_function = cache_translator; *)
(*     load_function = load_translator; *)
(*     open_function = open_translator; *)
(*     discharge_function = (fun (_, o) -> Some o); *)
(*     classify_function = (fun o -> Substitute o); *)
(*   } *)

(** Tactic *)

let empty_translator = Refmap.empty

let force_tac modality c id =
  Proofview.Goal.nf_enter begin fun gl ->
    let env = Proofview.Goal.env gl in
    let sigma = Proofview.Goal.sigma gl in
    let ans = MTranslate.translate modality env c in
    let sigma, _ = Typing.type_of env sigma ans in
    Proofview.Unsafe.tclEVARS sigma <*>
    Tactics.letin_tac None (Names.Name id) ans None Locusops.allHyps
  end
