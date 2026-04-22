TRUNCATE TABLE ECAMPAIGN.PA_TMP_PD_EFF_ARTICLE;

INSERT INTO ECAMPAIGN.PA_TMP_PD_EFF_ARTICLE
(
    PAYDISC_CODE,
    ARTICLE_CODE,
    BARCODE,
    CREATE_DATE,
    CREATE_BY,
    UPDATE_DATE,
    UPDATE_BY
)
SELECT DISTINCT
    PAYDISC_CODE,
    ARTICLE_CODE,
    BARCODE,
   :pCreateDate AS CREATE_DATE,
   :pCreateBy   AS CREATE_BY,
   :pCreateDate AS UPDATE_DATE,
   :pCreateBy   AS UPDATE_BY
FROM (
    SELECT
        m.PAYDISC_CODE AS PAYDISC_CODE,
        v.v_artno AS ARTICLE_CODE,
        a.arccode AS BARCODE
    FROM ECAMPAIGN.PA_TMP_PD_MASTER m
    INNER JOIN ECAMPAIGN.EFFECT_ARTICLE ea
        ON m.PAYDISC_CODE = ea.rule_id
    INNER JOIN ECAMPAIGN.V_BGC_ARTICLE_V5 v
        ON ea.article_code = v.v_artno
    INNER JOIN ECAMPAIGN.ARTCOCA a
        ON v.v_cint = a.arccinv
    WHERE NOT EXISTS (
            SELECT 1
            FROM ECAMPAIGN.EFFECT_HIERARCHY eh
            WHERE m.PAYDISC_CODE = eh.rule_id
        )
      AND NOT EXISTS (
            SELECT 1
            FROM ECAMPAIGN.EXCEPTION_SUPPLIER es
            WHERE es.rule_id = m.PAYDISC_CODE
              AND v.v_cnuf = es.supplier_code
        )
      AND NOT EXISTS (
            SELECT 1
            FROM ECAMPAIGN.EXCEPTION_BRAND eb
            WHERE eb.rule_id = m.PAYDISC_CODE
              AND v.v_brand_code = eb.brand_code
        )
      AND NOT EXISTS (
            SELECT 1
            FROM ECAMPAIGN.EXCEPTION_RULE er
            WHERE er.rule_id = m.PAYDISC_CODE
              AND v.v_artno = er.article_code
        )
      AND NOT EXISTS (
            SELECT 1
            FROM ECAMPAIGN.EXCEPTION_HIERARCHY exh
            WHERE m.PAYDISC_CODE = exh.rule_id
        )
      AND a.arcetat = 1
      AND SYSDATE BETWEEN a.arcddeb AND a.arcdfin
      AND DECODE(a.arcieti, 0, DECODE(a.arctcod, 5, 0, 1), 1) = 1
);