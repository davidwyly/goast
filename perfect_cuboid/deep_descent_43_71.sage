from sage.all import *
import time, traceback

proof.all(True)
pari.allocatemem(3_000_000_000)

Eorig = EllipticCurve(QQ, [0,
    164592131218369,
    0,
    6688154288713723299763380000,
    79395460176636941951814993631822707360000])
Emin = EllipticCurve(QQ, [1,0,0,
    -146377224851325609522351670,
    667886864751009985149216219926929986212])
phi=Emin.isomorphism_to(Eorig)
print('DEEP_GENERATOR_START',flush=True)
print('RANK_SAGE',Emin.rank(proof=True,only_use_mwrank=False),flush=True)

found=[]
for lim in [13,15,17,19,21,24]:
    print('LIMIT_START',lim,flush=True)
    t=time.time()
    try:
        td=Emin.two_descent(second_limit=lim)
        print('TWO_DESCENT',lim,td,'SECONDS',time.time()-t,flush=True)
    except Exception as exc:
        print('TWO_DESCENT_ERROR',lim,repr(exc),'SECONDS',time.time()-t,flush=True)
        traceback.print_exc()
    for kwargs in [
        {'proof':True,'descent_second_limit':lim},
        {'proof':False,'descent_second_limit':lim},
        {'proof':True},
        {'proof':False},
    ]:
        t2=time.time()
        try:
            gs=Emin.gens(**kwargs)
            print('GENS',lim,kwargs,gs,'SECONDS',time.time()-t2,flush=True)
            if gs:
                found=gs
                break
        except Exception as exc:
            print('GENS_ERROR',lim,kwargs,repr(exc),'SECONDS',time.time()-t2,flush=True)
    if found:
        break

if found:
    print('GENERATOR_MIN',found,flush=True)
    print('GENERATOR_ORIG',[phi(P) for P in found],flush=True)
    print('HEIGHTS',[P.height() for P in found],flush=True)
    open('deep-descent-43-71-point.txt','w').write(
        'Pmin=%s\nPorig=%s\nheights=%s\n' % (found,[phi(P) for P in found],[P.height() for P in found]))
    print('DEEP_GENERATOR_FOUND True',flush=True)
else:
    print('DEEP_GENERATOR_FOUND False',flush=True)
print('DEEP_GENERATOR_COMPLETE True',flush=True)
