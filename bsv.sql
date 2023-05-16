DROP FUNCTION bsv(double precision,double precision,double precision,double precision,double precision) ;

CREATE OR REPLACE FUNCTION bsv(s0 float8, k float8, tt float8, r float8, sigma float8) RETURNS float8 AS
$CODE$
    import numpy as np

    M=50; dt= tt / M; I =250000
    S=np.zeros((M + 1, I))
    S[0] = s0
    for t in range(1, M+1):
        z = np.random.standard_normal(I)
        S[t] = S[t - 1] * np.exp((r - 0.5 * sigma ** 2) * dt + sigma * np.sqrt(dt) * z)

    C0 = np.exp(-r * tt) * np.sum(np.maximum(S[-1] - k, 0)) / I
    return C0
$CODE$ LANGUAGE plpythonu;

SELECT bsv(100, 105, 1.0, 0.05, 0.2)
    