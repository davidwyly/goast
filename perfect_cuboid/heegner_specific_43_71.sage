from sage.all import *
import time, traceback
proof.all(True)

D=ZZ(-50231)
Eorig = EllipticCurve(QQ, [0,
    164592131218369,0,
    6688154288713723299763380000,
    79395460176636941951814993631822707360000])
Emin = EllipticCurve(QQ, [1,0,0,
    -146377224851325609522351670,
    667886864751009985149216219926929986212])
phi=Emin.isomorphism_to(Eorig)
print('SPECIFIC_HEEGNER_START',D,flush=True)
print('HEEGNER_HYPOTHESIS',Emin.satisfies_heegner_hypothesis(D),flush=True)
print('CLASS_NUMBER',D.class_number(),flush=True)
print('ANALYTIC_RANK',Emin.analytic_rank(),flush=True)

try:
    t=time.time(); H=Emin.heegner_point(D)
    print('HEEGNER_OBJECT',H,flush=True)
    print('HEEGNER_OBJECT_SECONDS',time.time()-t,flush=True)
    print('HEEGNER_DIR',[x for x in dir(H) if 'point' in x or 'exact' in x or 'index' in x],flush=True)
    exact=None
    for name,args in [
        ('point_exact',()),('point_exact',(200,)),('point',()),('rational_point',()),
    ]:
        if not hasattr(H,name):continue
        try:
            t2=time.time(); val=getattr(H,name)(*args)
            print('METHOD',name,args,'RESULT',val,'SECONDS',time.time()-t2,flush=True)
            if val is not None:
                try:
                    exact=Emin(val)
                    if not exact.is_zero():break
                except Exception:pass
        except Exception as exc:
            print('METHOD_ERROR',name,args,repr(exc),flush=True)
            traceback.print_exc()
    if exact is None:
        raise RuntimeError('No exact rational point returned by Heegner object')
    print('SPECIFIC_PMIN',exact,flush=True)
    print('SPECIFIC_PORIG',phi(exact),flush=True)
    print('SPECIFIC_HEIGHT',exact.height(),flush=True)
    try:
        print('SPECIFIC_SATURATION',Emin.saturation([exact],max_prime=100000,proof=True),flush=True)
    except Exception as exc:
        print('SPECIFIC_SATURATION_ERROR',repr(exc),flush=True)
    open('heegner-specific-43-71-point.txt','w').write(
        'D=%s\nPmin=%s\nPorig=%s\nheight=%s\n' % (D,exact,phi(exact),exact.height()))
    print('SPECIFIC_HEEGNER_FOUND True',flush=True)
except Exception as exc:
    print('SPECIFIC_HEEGNER_ERROR',repr(exc),flush=True)
    traceback.print_exc()
    print('SPECIFIC_HEEGNER_FOUND False',flush=True)
print('SPECIFIC_HEEGNER_COMPLETE True',flush=True)
