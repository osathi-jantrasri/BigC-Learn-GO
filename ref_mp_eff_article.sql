    DBMS_OUTPUT.PUT_LINE('9. Insert data to HK_TMP_MP_EFF_ARTICLE.');
    INSERT INTO HK_TMP_MP_EFF_ARTICLE(MEMPRICE_CODE,ARTICLE_CODE,BARCODE, CREATE_DATE,CREATE_BY,UPDATE_DATE,UPDATE_BY)
        select distinct MEMPRICE_CODE,v_artno, barcode,VAR_CREATE_DATE,VAR_CREATE_BY,VAR_CREATE_DATE,VAR_CREATE_BY
        from
        ((select a.memprc_code MEMPRICE_CODE,
            v.v_artno,
            decode(arctcod,4,substr(m.arccode,1,7)||'00000'||
            SUBSTR(TO_CHAR(1000 - (
            (NVL(SUBSTR(m.arccode, 1, 1),0) * 1) +
            (NVL(SUBSTR(m.arccode, 2, 1),0) * 3) +
            (NVL(SUBSTR(m.arccode, 3, 1),0) * 1) +
            (NVL(SUBSTR(m.arccode, 4, 1),0) * 3) +
            (NVL(SUBSTR(m.arccode, 5, 1),0) * 1) +
            (NVL(SUBSTR(m.arccode, 6, 1),0) * 3) +
            (NVL(SUBSTR(m.arccode, 7, 1),0) * 1))) , -1),
            DECODE(SIGN(LENGTH(M.arccode)-13), -1, LPAD(M.arccode, 13, '0'), M.arccode)) barcode
        from memprc_price a,effect_article p,V_BGC_ARTICLE_V5 v,artcoca m ,EFFECT_SPECIALDAY ES
        where  p.article_code = v.v_artno and a.memprc_code = p.rule_id
            and a.status = 'AP'
            and not exists(select 1 from effect_hierarchy e
            where a.memprc_code = e.rule_id)
            and not exists(select 1 from exception_supplier e where e.rule_id = a.memprc_code and v.v_cnuf = e.supplier_code)
            and not exists(select 1 from exception_brand e where e.rule_id = a.memprc_code and v.v_brand_code = e.brand_code )
            and not exists(select 1 from exception_rule e where e.rule_id = a.memprc_code and v.v_artno = e.article_code)
            and not exists(select 1 from exception_hierarchy e
            where a.memprc_code = e.rule_id)
            and m.arcetat = 1
            and v.v_cint = m.arccinv
            and SYSDATE between m.arcddeb and m.arcdfin
            AND ( DECODE(m.arcieti, 0, DECODE(m.arctcod, 5, 0, 1), 1) = 1 )
            and trunc(var_effective_date) BETWEEN trunc(start_date) and trunc(end_date)
            AND  a.memprc_code = ES.RULE_ID(+)
            AND TRUNC(var_effective_date) = TRUNC(NVL(ES.SPECIAL_DATE,TRUNC(var_effective_date)))
            AND HK_CHECK_STORE_BY_PROMO(VAR_PROMOTION_NAME,A.MEMPRC_CODE) ='T'
        ) UNION (select a.memprc_code MEMPRICE_CODE,
            v.v_artno,
            decode(arctcod,4,substr(m.arccode,1,7)||'00000'||
            SUBSTR(TO_CHAR(1000 - (
            (NVL(SUBSTR(m.arccode, 1, 1),0) * 1) +
            (NVL(SUBSTR(m.arccode, 2, 1),0) * 3) +
            (NVL(SUBSTR(m.arccode, 3, 1),0) * 1) +
            (NVL(SUBSTR(m.arccode, 4, 1),0) * 3) +
            (NVL(SUBSTR(m.arccode, 5, 1),0) * 1) +
            (NVL(SUBSTR(m.arccode, 6, 1),0) * 3) +
            (NVL(SUBSTR(m.arccode, 7, 1),0) * 1))) , -1),
            DECODE(SIGN(LENGTH(M.arccode)-13), -1, LPAD(M.arccode, 13, '0'), M.arccode)) barcode
        from memprc_price a,effect_supplier p,V_BGC_ARTICLE_V5 v,artcoca m ,EFFECT_SPECIALDAY ES
        where  p.supplier_code = v.v_cnuf and a.memprc_code = p.rule_id
            and a.status = 'AP'
            and not exists(select 1 from effect_hierarchy e
            where a.memprc_code = e.rule_id)
            and not exists(select 1 from exception_supplier e where e.rule_id = a.memprc_code and v.v_cnuf = e.supplier_code)
            and not exists(select 1 from exception_brand e where e.rule_id = a.memprc_code and v.v_brand_code = e.brand_code )
            and not exists(select 1 from exception_rule e where e.rule_id = a.memprc_code and v.v_artno = e.article_code)
            and not exists(select 1 from exception_hierarchy e
            where a.memprc_code = e.rule_id)
            and m.arcetat = 1
            and v.v_cint = m.arccinv
            and SYSDATE between m.arcddeb and m.arcdfin
            AND ( DECODE(m.arcieti, 0, DECODE(m.arctcod, 5, 0, 1), 1) = 1 )
            and trunc(var_effective_date) BETWEEN trunc(start_date) and trunc(end_date)
            AND  a.memprc_code = ES.RULE_ID(+)
            AND TRUNC(var_effective_date) = TRUNC(NVL(ES.SPECIAL_DATE,TRUNC(var_effective_date)))
            AND HK_CHECK_STORE_BY_PROMO(VAR_PROMOTION_NAME,A.MEMPRC_CODE) ='T')
        );
    COMMIT ;