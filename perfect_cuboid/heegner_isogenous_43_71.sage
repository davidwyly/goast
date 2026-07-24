from sage.all import *
import os,time,traceback
proof.all(True)
pari.allocatemem(3_000_000_000)
idx=ZZ(os.environ.get('CURVE_INDEX','0'))
models=[
 [1,0,0,-146377224851325609522351670,667886864751009985149216219926929986212],
 [1,0,0,-145554995198399631312046390,675909541463824109648054427504521684900],
 [1,0,0,16619590868955793753154330,2073207464211354377273165775423659105012],
 [1,0,0,-322529715018422664162742150,-1250885044329435085981766916622826627500],
]
E=EllipticCurve(QQ,models[idx])
E0=EllipticCurve(QQ,models[0])
print('ISOGENOUS_HEEGNER_START',idx,E,flush=True)
print('CONDUCTOR',E.conductor(),'ROOT',E.root_number(),'ANRANK',E.analytic_rank(),flush=True)
try:
 t=time.time();PE=pari.ellinit(pari(list(E.a_invariants())));h=pari.ellheegner(PE)
 print('ISOGENOUS_ELLHEEGNER_RAW',idx,h,'SECONDS',time.time()-t,flush=True)
 P=E(QQ(h[0].sage()),QQ(h[1].sage()))
 print('ISOGENOUS_POINT',idx,P,'HEIGHT',P.height(),flush=True)
 if idx==0:
  P0=P
 else:
  P0=None
  try:
   iso=E.isogeny_to(E0)
   P0=iso(P)
   print('ISOGENY_TO_ORIGINAL',iso,flush=True)
  except Exception as exc:
   print('ISOGENY_TO_ORIGINAL_ERROR',repr(exc),flush=True)
   try:
    cls=E.isogeny_class()
    print('ISOGENY_CLASS',cls.curves,flush=True)
   except Exception as exc2: print('ISOGENY_CLASS_ERROR',repr(exc2),flush=True)
  if P0 is not None: print('ORIGINAL_POINT',P0,'HEIGHT',P0.height(),flush=True)
 open('heegner-isogenous-%s-point.txt'%idx,'w').write('curve=%s\nP=%s\nP0=%s\n'%(E,P,P0))
 print('ISOGENOUS_HEEGNER_FOUND',idx,True,flush=True)
except Exception as exc:
 print('ISOGENOUS_HEEGNER_ERROR',idx,repr(exc),flush=True);traceback.print_exc();print('ISOGENOUS_HEEGNER_FOUND',idx,False,flush=True)
print('ISOGENOUS_HEEGNER_COMPLETE',idx,True,flush=True)
