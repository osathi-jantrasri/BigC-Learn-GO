    DBMS_OUTPUT.PUT_LINE('[Start] 8.HK_TMP_PD_EFF_ARTICLE');
    INSERT INTO HK_TMP_PD_EFF_ARTICLE
        (PAYDISCCODE,
         ARTICLE_CODE,
         BARCODE,
         CREATE_DATE,
         CREATE_BY,
         UPDATE_DATE,
         UPDATE_BY
         )
        SELECT DISTINCT PAYDISCCODE,
                        V_ARTNO,
                        BARCODE,
                        VAR_CREATE_DATE,
                        VAR_CREATE_BY,
                        VAR_CREATE_DATE,
                        VAR_CREATE_BY
          FROM (
            (SELECT T1.PAYDISCCODE,
                        V.V_ARTNO,
                        DECODE(ARCTCOD,
                               4,
                               SUBSTR(M.ARCCODE, 1, 7) || '00000' ||
                               SUBSTR(TO_CHAR(1000 -
                                              ((NVL(SUBSTR(M.ARCCODE, 1, 1),
                                                    0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 2, 1),
                                                    0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 3, 1),
                                                    0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 4, 1),
                                                    0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 5, 1),
                                                    0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 6, 1),
                                                    0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 7, 1),
                                                    0) * 1))),
                                      -1),
                               DECODE(SIGN(LENGTH(M.ARCCODE) - 13),
                                      -1,
                                      LPAD(M.ARCCODE, 13, '0'),
                                      M.ARCCODE)) BARCODE
                   FROM PAYMENTDISC_TITLE        T1,
                        EFFECT_ARTICLE           P,
                        V_BGC_ARTICLE_V5         V,
                        ARTCOCA@GOLD5DB          M,
                        EFFECT_SPECIALDAY        ES
                  WHERE T1.PAYDISCCODE = P.RULE_ID
                    AND T1.STATUS = 'AP'
                    AND P.ARTICLE_CODE = V.V_ARTNO
                    AND NOT EXISTS
                  (SELECT 1
                           FROM EFFECT_HIERARCHY E
                          WHERE T1.PAYDISCCODE = E.RULE_ID
                            AND LPAD(E.DIV_CODE, 2, '0') =
                                LPAD(V_NIV1, 2, '0')
                            AND NVL(LPAD(E.DEPT_CODE, 2, '0'), '00') =
                                NVL(LPAD(V_NIV2, 2, '0'), '00')
                            AND NVL(LPAD(E.SUBDEPT_CODE, 2, '0'), '00') =
                                NVL(LPAD(V_NIV3, 2, '0'), '00')
                            AND NVL(NVL(E.CLASS_CODE, V_NIV4), '00') =
                                NVL(V_NIV4, '00')
                            AND NVL(NVL(E.SUBCLASS_CODE, V_NIV5), '00') =
                                NVL(V_NIV5, '00'))
                    AND NOT EXISTS (SELECT 1
                           FROM EXCEPTION_SUPPLIER E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_CNUF = E.SUPPLIER_CODE)
                    AND NOT EXISTS
                  (SELECT 1
                           FROM EXCEPTION_BRAND E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_BRAND_CODE = E.BRAND_CODE)
                    AND NOT EXISTS (SELECT 1
                           FROM EXCEPTION_RULE E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_ARTNO = E.ARTICLE_CODE)
                    AND NOT EXISTS
                  (SELECT 1
                           FROM EXCEPTION_HIERARCHY E
                          WHERE T1.PAYDISCCODE = E.RULE_ID
                            AND LPAD(E.DIV_CODE, 2, '0') =
                                LPAD(V_NIV1, 2, '0')
                            AND NVL(LPAD(E.DEPT_CODE, 2, '0'), '00') =
                                NVL(LPAD(V_NIV2, 2, '0'), '00')
                            AND NVL(LPAD(E.SUBDEPT_CODE, 2, '0'), '00') =
                                NVL(LPAD(V_NIV3, 2, '0'), '00')
                            AND NVL(NVL(E.CLASS_CODE, V_NIV4), '00') =
                                NVL(V_NIV4, '00')
                            AND NVL(NVL(E.SUBCLASS_CODE, V_NIV5), '00') =
                                NVL(V_NIV5, '00'))
                    AND M.ARCETAT = 1
                    AND V.V_CINT = M.ARCCINV
                    AND SYSDATE BETWEEN M.ARCDDEB AND M.ARCDFIN
                    AND (DECODE(M.ARCIETI, 0, DECODE(M.ARCTCOD, 5, 0, 1), 1) = 1)
                    AND TRUNC(VAR_EFFECTIVE_DATE) BETWEEN TRUNC(T1.START_DATE) AND
                        TRUNC(T1.END_DATE)
                    AND T1.PAYDISCCODE = ES.RULE_ID(+)
                    AND TRUNC(VAR_EFFECTIVE_DATE) =
                        TRUNC(NVL(ES.SPECIAL_DATE, TRUNC(VAR_EFFECTIVE_DATE)))
                    AND (TRUNC(VAR_EFFECTIVE_DATE) NOT BETWEEN
                        TRUNC(T1.HOLD_START_DATE) AND
                        TRUNC(T1.HOLD_END_DATE) OR
                        (T1.HOLD_START_DATE IS NULL OR
                        T1.HOLD_END_DATE IS NULL))
                     AND HK_CHECK_STORE_BY_PROMO(VAR_PROMOTION_NAME,T1.PAYDISCCODE) = 'T' )
          UNION
            (SELECT T1.PAYDISCCODE,
                        V.V_ARTNO,
                        DECODE(ARCTCOD,
                               4,
                               SUBSTR(M.ARCCODE, 1, 7) || '00000' ||
                               SUBSTR(TO_CHAR(1000 -
                                              ((NVL(SUBSTR(M.ARCCODE, 1, 1), 0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 2, 1), 0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 3, 1), 0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 4, 1), 0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 5, 1), 0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 6, 1), 0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 7, 1), 0) * 1))),
                                      -1),
                               DECODE(SIGN(LENGTH(M.ARCCODE) - 13),
                                      -1,
                                      LPAD(M.ARCCODE, 13, '0'),
                                      M.ARCCODE)) BARCODE
                   FROM PAYMENTDISC_TITLE        T1,
                        EFFECT_SUPPLIER          P,
                        V_BGC_ARTICLE_V5         V,
                        ARTCOCA@GOLD5DB          M,
                        EFFECT_SPECIALDAY        ES
                  WHERE T1.PAYDISCCODE = P.RULE_ID
                    AND T1.STATUS = 'AP'
                    AND P.SUPPLIER_CODE = V.V_CNUF
                    AND NOT EXISTS
                  (SELECT 1
                           FROM EFFECT_HIERARCHY E
                          WHERE T1.PAYDISCCODE = E.RULE_ID
                            AND LPAD(E.DIV_CODE, 2, '0') =
                                LPAD(V_NIV1, 2, '0')
                            AND NVL(LPAD(E.DEPT_CODE, 2, '0'), '00') =
                                NVL(LPAD(V_NIV2, 2, '0'), '00')
                            AND NVL(LPAD(E.SUBDEPT_CODE, 2, '0'), '00') =
                                NVL(LPAD(V_NIV3, 2, '0'), '00')
                            AND NVL(NVL(E.CLASS_CODE, V_NIV4), '00') =
                                NVL(V_NIV4, '00')
                            AND NVL(NVL(E.SUBCLASS_CODE, V_NIV5), '00') =
                                NVL(V_NIV5, '00'))
                    AND NOT EXISTS (SELECT 1
                           FROM EXCEPTION_SUPPLIER E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_CNUF = E.SUPPLIER_CODE)
                    AND NOT EXISTS (SELECT 1
                           FROM EXCEPTION_BRAND E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_BRAND_CODE = E.BRAND_CODE)
                    AND NOT EXISTS (SELECT 1
                           FROM EXCEPTION_RULE E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_ARTNO = E.ARTICLE_CODE)
                    AND NOT EXISTS
                  (SELECT 1
                           FROM EXCEPTION_HIERARCHY E
                          WHERE T1.PAYDISCCODE = E.RULE_ID
                            AND LPAD(E.DIV_CODE, 2, '0') =
                                LPAD(V_NIV1, 2, '0')
                            AND NVL(LPAD(E.DEPT_CODE, 2, '0'), '00') =
                                NVL(LPAD(V_NIV2, 2, '0'), '00')
                            AND NVL(LPAD(E.SUBDEPT_CODE, 2, '0'), '00') =
                                NVL(LPAD(V_NIV3, 2, '0'), '00')
                            AND NVL(NVL(E.CLASS_CODE, V_NIV4), '00') =
                                NVL(V_NIV4, '00')
                            AND NVL(NVL(E.SUBCLASS_CODE, V_NIV5), '00') =
                                NVL(V_NIV5, '00'))
                    AND M.ARCETAT = 1
                    AND V.V_CINT = M.ARCCINV
                    AND SYSDATE BETWEEN M.ARCDDEB AND M.ARCDFIN
                    AND (DECODE(M.ARCIETI, 0, DECODE(M.ARCTCOD, 5, 0, 1), 1) = 1)
                    AND TRUNC(VAR_EFFECTIVE_DATE) BETWEEN TRUNC(T1.START_DATE) AND
                        TRUNC(T1.END_DATE)
                    AND T1.PAYDISCCODE = ES.RULE_ID(+)
                    AND TRUNC(VAR_EFFECTIVE_DATE) =
                        TRUNC(NVL(ES.SPECIAL_DATE, TRUNC(VAR_EFFECTIVE_DATE)))
                       -- HOLD_START_DATE AND HOLD_END_DATE
                    AND (TRUNC(VAR_EFFECTIVE_DATE) NOT BETWEEN
                        TRUNC(T1.HOLD_START_DATE) AND
                        TRUNC(T1.HOLD_END_DATE) OR (T1.HOLD_START_DATE IS NULL OR
                        T1.HOLD_END_DATE IS NULL))
                  AND HK_CHECK_STORE_BY_PROMO(VAR_PROMOTION_NAME, T1.PAYDISCCODE) = 'T' )
          UNION
                SELECT
                T1.PAYDISCCODE, V.V_ARTNO,
                DECODE(ARCTCOD,
                       4,
                       SUBSTR(M.ARCCODE, 1, 7) || '00000' ||
                       SUBSTR(TO_CHAR(1000 -
                                      ((NVL(SUBSTR(M.ARCCODE, 1, 1), 0) * 1) +
                                      (NVL(SUBSTR(M.ARCCODE, 2, 1), 0) * 3) +
                                      (NVL(SUBSTR(M.ARCCODE, 3, 1), 0) * 1) +
                                      (NVL(SUBSTR(M.ARCCODE, 4, 1), 0) * 3) +
                                      (NVL(SUBSTR(M.ARCCODE, 5, 1), 0) * 1) +
                                      (NVL(SUBSTR(M.ARCCODE, 6, 1), 0) * 3) +
                                      (NVL(SUBSTR(M.ARCCODE, 7, 1), 0) * 1))),
                              -1),
                       DECODE(SIGN(LENGTH(M.ARCCODE) - 13),
                              -1,
                              LPAD(M.ARCCODE, 13, '0'),
                              M.ARCCODE)) BARCODE FROM PAYMENTDISC_TITLE T1,
                EFFECT_ARTICLE P, V_BGC_ARTICLE_V5 V, ARTCOCA@GOLD5DB M,
                CFG_USER_PRODUCT CUP, EFFECT_SPECIALDAY ES WHERE
                T1.PAYDISCCODE = P.RULE_ID AND T1.STATUS = 'AP' AND
                P.ARTICLE_CODE = V.V_ARTNO

                AND CUP.USER_CODE = T1.CREATE_BY AND
                CUP.DIVISION_CODE = V.V_NIV1 AND
                (CUP.DEPT_CODE IS NULL OR CUP.DEPT_CODE = V.V_NIV2) AND
                (CUP.SUB_DEPT_CODE IS NULL OR CUP.SUB_DEPT_CODE = V.V_NIV3)

                AND NOT EXISTS
                (SELECT 1
                   FROM EFFECT_HIERARCHY E
                  WHERE T1.PAYDISCCODE = E.RULE_ID
                    AND E.DIV_CODE = V.V_NIV1
                    AND (E.DEPT_CODE IS NULL OR E.DEPT_CODE = V.V_NIV2)
                    AND (E.SUBDEPT_CODE IS NULL OR E.SUBDEPT_CODE = V.V_NIV3)) AND
                NOT EXISTS
                (SELECT 1
                   FROM EXCEPTION_SUPPLIER E
                  WHERE E.RULE_ID = T1.PAYDISCCODE
                    AND V.V_CNUF = E.SUPPLIER_CODE) AND NOT EXISTS
                (SELECT 1
                   FROM EXCEPTION_BRAND E
                  WHERE E.RULE_ID = T1.PAYDISCCODE
                    AND V.V_BRAND_CODE = E.BRAND_CODE) AND NOT EXISTS
                (SELECT 1
                   FROM EXCEPTION_RULE E
                  WHERE E.RULE_ID = T1.PAYDISCCODE
                    AND V.V_ARTNO = E.ARTICLE_CODE) AND NOT EXISTS
                (SELECT 1
                   FROM EXCEPTION_HIERARCHY E
                  WHERE T1.PAYDISCCODE = E.RULE_ID
                    AND E.DIV_CODE = V.V_NIV1
                    AND (E.DEPT_CODE IS NULL OR E.DEPT_CODE = V.V_NIV2)
                    AND (E.SUBDEPT_CODE IS NULL OR E.SUBDEPT_CODE = V.V_NIV3)) AND
                M.ARCETAT = 1 AND V.V_CINT = M.ARCCINV AND
                SYSDATE BETWEEN M.ARCDDEB AND M.ARCDFIN AND
                (DECODE(M.ARCIETI, 0, DECODE(M.ARCTCOD, 5, 0, 1), 1) = 1) AND
                TRUNC(VAR_EFFECTIVE_DATE) BETWEEN TRUNC(T1.START_DATE) AND
                TRUNC(T1.END_DATE) AND T1.PAYDISCCODE = ES.RULE_ID(+) AND
                TRUNC(VAR_EFFECTIVE_DATE) =
                TRUNC(NVL(ES.SPECIAL_DATE, TRUNC(VAR_EFFECTIVE_DATE)))

                AND (TRUNC(VAR_EFFECTIVE_DATE) NOT BETWEEN TRUNC(T1.HOLD_START_DATE) AND TRUNC(T1.HOLD_END_DATE)
                         OR (T1.HOLD_START_DATE IS NULL OR T1.HOLD_END_DATE IS NULL))
                AND HK_CHECK_STORE_BY_PROMO(VAR_PROMOTION_NAME,T1.PAYDISCCODE) = 'T'
        UNION
                (SELECT T1.PAYDISCCODE,
                        V.V_ARTNO,
                        DECODE(ARCTCOD,
                               4,
                               SUBSTR(M.ARCCODE, 1, 7) || '00000' ||
                               SUBSTR(TO_CHAR(1000 -
                                              ((NVL(SUBSTR(M.ARCCODE, 1, 1), 0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 2, 1), 0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 3, 1), 0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 4, 1), 0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 5, 1), 0) * 1) +
                                              (NVL(SUBSTR(M.ARCCODE, 6, 1), 0) * 3) +
                                              (NVL(SUBSTR(M.ARCCODE, 7, 1), 0) * 1))),
                                      -1),
                               DECODE(SIGN(LENGTH(M.ARCCODE) - 13),
                                      -1,
                                      LPAD(M.ARCCODE, 13, '0'),
                                      M.ARCCODE)) BARCODE
                   FROM PAYMENTDISC_TITLE T1,
                        EFFECT_SUPPLIER   P,
                        V_BGC_ARTICLE_V5  V,
                        ARTCOCA@GOLD5DB   M,
                        CFG_USER_PRODUCT  CUP,
                        EFFECT_SPECIALDAY ES
                  WHERE T1.PAYDISCCODE = P.RULE_ID
                    AND T1.STATUS = 'AP'
                    AND P.SUPPLIER_CODE = V.V_CNUF

                    AND CUP.USER_CODE = T1.CREATE_BY
                    AND CUP.DIVISION_CODE = V.V_NIV1
                    AND (CUP.DEPT_CODE IS NULL OR CUP.DEPT_CODE = V.V_NIV2)
                    AND (CUP.SUB_DEPT_CODE IS NULL OR
                        CUP.SUB_DEPT_CODE = V.V_NIV3)

                    AND NOT EXISTS
                  (SELECT 1
                           FROM EFFECT_HIERARCHY E
                          WHERE T1.PAYDISCCODE = E.RULE_ID
                            AND E.DIV_CODE = V.V_NIV1
                            AND (E.DEPT_CODE IS NULL OR E.DEPT_CODE = V.V_NIV2)
                            AND (E.SUBDEPT_CODE IS NULL OR
                                E.SUBDEPT_CODE = V.V_NIV3))
                    AND NOT EXISTS (SELECT 1
                           FROM EXCEPTION_SUPPLIER E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_CNUF = E.SUPPLIER_CODE)
                    AND NOT EXISTS (SELECT 1
                           FROM EXCEPTION_BRAND E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_BRAND_CODE = E.BRAND_CODE)
                    AND NOT EXISTS (SELECT 1
                           FROM EXCEPTION_RULE E
                          WHERE E.RULE_ID = T1.PAYDISCCODE
                            AND V.V_ARTNO = E.ARTICLE_CODE)
                    AND NOT EXISTS
                  (SELECT 1
                           FROM EXCEPTION_HIERARCHY E
                          WHERE T1.PAYDISCCODE = E.RULE_ID
                            AND E.DIV_CODE = V.V_NIV1
                            AND (E.DEPT_CODE IS NULL OR E.DEPT_CODE = V.V_NIV2)
                            AND (E.SUBDEPT_CODE IS NULL OR
                                E.SUBDEPT_CODE = V.V_NIV3))
                    AND M.ARCETAT = 1
                    AND V.V_CINT = M.ARCCINV
                    AND SYSDATE BETWEEN M.ARCDDEB AND M.ARCDFIN
                    AND (DECODE(M.ARCIETI, 0, DECODE(M.ARCTCOD, 5, 0, 1), 1) = 1)
                    AND TRUNC(VAR_EFFECTIVE_DATE) BETWEEN TRUNC(T1.START_DATE) AND
                        TRUNC(T1.END_DATE)
                    AND T1.PAYDISCCODE = ES.RULE_ID(+)
                    AND TRUNC(VAR_EFFECTIVE_DATE) =
                        TRUNC(NVL(ES.SPECIAL_DATE, TRUNC(VAR_EFFECTIVE_DATE)))
                       -- HOLD_START_DATE AND HOLD_END_DATE
                    AND (TRUNC(VAR_EFFECTIVE_DATE) NOT BETWEEN
                        TRUNC(T1.HOLD_START_DATE) AND
                        TRUNC(T1.HOLD_END_DATE) OR (T1.HOLD_START_DATE IS NULL OR
                        T1.HOLD_END_DATE IS NULL))
                   AND HK_CHECK_STORE_BY_PROMO(VAR_PROMOTION_NAME, T1.PAYDISCCODE) = 'T'
           ));
    COMMIT ;