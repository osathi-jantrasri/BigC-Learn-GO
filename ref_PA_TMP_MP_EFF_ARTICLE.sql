INSERT INTO "ECAMPAIGN"."PA_TMP_MP_EFF_ARTICLE"
(
    MEMPRICE_CODE,
    ARTICLE_CODE,
    BARCODE,
    CREATE_DATE,
    CREATE_BY,
    UPDATE_DATE,
    UPDATE_BY
)
SELECT DISTINCT
    MEMPRICE_CODE,
    v_artno,
    barcode,
    :pCreateDate AS CREATE_DATE,
    :pCreateBy   AS CREATE_BY,
    :pCreateDate AS UPDATE_DATE,
    :pCreateBy   AS UPDATE_BY
FROM (
    SELECT
        a.MEMPRICE_CODE AS MEMPRICE_CODE,
        v.v_artno,
        m.arccode AS barcode
    FROM PA_TMP_MP_MASTER a
    INNER JOIN effect_article p
        ON a.MEMPRICE_CODE = p.rule_id
    INNER JOIN V_BGC_ARTICLE_V5 v
        ON p.article_code = v.v_artno
    INNER JOIN artcoca m
        ON v.v_cint = m.arccinv
    WHERE a.status = 'AP'
        AND NOT EXISTS (
            SELECT 1
            FROM effect_hierarchy e
            WHERE a.MEMPRICE_CODE = e.rule_id
        )
        AND NOT EXISTS (
            SELECT 1
            FROM exception_supplier e
            WHERE e.rule_id = a.MEMPRICE_CODE
              AND v.v_cnuf = e.supplier_code
        )
        AND NOT EXISTS (
            SELECT 1
            FROM exception_brand e
            WHERE e.rule_id = a.MEMPRICE_CODE
              AND v.v_brand_code = e.brand_code
        )
        AND NOT EXISTS (
            SELECT 1
            FROM exception_rule e
            WHERE e.rule_id = a.MEMPRICE_CODE
              AND v.v_artno = e.article_code
        )
        AND NOT EXISTS (
            SELECT 1
            FROM exception_hierarchy e
            WHERE a.MEMPRICE_CODE = e.rule_id
        )
        AND m.arcetat = 1
        AND SYSDATE BETWEEN m.arcddeb AND m.arcdfin
        AND (DECODE(m.arcieti, 0, DECODE(m.arctcod, 5, 0, 1), 1) = 1)
);
