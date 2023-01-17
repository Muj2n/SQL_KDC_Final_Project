-- 1. 서비스 이용데이터(총 구매횟수, 총 구매금액, 평균 구매금액)에 대한 5등급 구분
-- 2. 1등급에 해당하는 고객의 랭킹(RANK() OVER (ORDER BY [컬럼 이름])) + 서비스 이용데이터(총 구매횟수, 총 구매금액, 평균 구매금액)
-- 3. 고객번호 : Customer_id가 KEY
-- 4. 열 : 1000 따라서 200개가 1등급에 해당

-- 1) 총 구매횟수
/*
SELECT  RANK() OVER(ORDER BY count(fastcampus.orders.customer_id) DESC) AS RANK_COUNT, -- 고객의 랭킹
		fastcampus.orders.customer_id AS CUSTOMER_ID, 								   -- 고객 ID
		fastcampus.customers.customer_name AS CUSTOMER_NAME,						   -- 이름
		fastcampus.customers.gender AS CUSTOMER_GENDER,						           -- 성별
        fastcampus.customers.age AS CUSTOMER_AGE,                                      -- 나이
        fastcampus.customers.home_address AS CUSTOMER_HOME_ADDRESS,                    -- 주소
        count(fastcampus.orders.customer_id) AS COUNT_CUSTOMER, 					   -- 총 거래 횟수
		AVG(fastcampus.orders.payment) AS AVG_PAYMENT,								   -- 평균 구매금액
		SUM(fastcampus.orders.payment) AS SUM_PAYMENT								   -- 총 구매금액
        
FROM fastcampus.orders
INNER JOIN fastcampus.customers
ON fastcampus.orders.customer_id = fastcampus.customers.customer_id
WHERE fastcampus.orders.customer_id > 0
GROUP BY fastcampus.orders.customer_id,
		 fastcampus.customers.customer_name,
         fastcampus.customers.gender,
         fastcampus.customers.age,
         fastcampus.customers.home_address
LIMIT 200;
*/

/*
-- 2) 총 구매금액
SELECT  RANK() OVER(ORDER BY SUM(fastcampus.orders.payment) DESC) AS RANK_SUM,         -- 고객의 랭킹
		fastcampus.orders.customer_id AS CUSTOMER_ID, 								   -- 고객 ID
		fastcampus.customers.customer_name AS CUSTOMER_NAME,						   -- 이름
		fastcampus.customers.gender AS CUSTOMER_GENDER,						           -- 성별
        fastcampus.customers.age AS CUSTOMER_AGE,                                      -- 나이
        fastcampus.customers.home_address AS CUSTOMER_HOME_ADDRESS,                    -- 주소
        count(fastcampus.orders.customer_id) AS COUNT_CUSTOMER, 					   -- 총 거래 횟수
		AVG(fastcampus.orders.payment) AS AVG_PAYMENT,								   -- 평균 구매금액
		SUM(fastcampus.orders.payment) AS SUM_PAYMENT								   -- 총 구매금액
        
FROM fastcampus.orders
INNER JOIN fastcampus.customers
ON fastcampus.orders.customer_id = fastcampus.customers.customer_id
WHERE fastcampus.orders.customer_id > 0
GROUP BY fastcampus.orders.customer_id,
		 fastcampus.customers.customer_name,
         fastcampus.customers.gender,
         fastcampus.customers.age,
         fastcampus.customers.home_address
LIMIT 200;
*/

/*
-- 3) 평균 구매금액
SELECT  RANK() OVER(ORDER BY AVG(fastcampus.orders.payment) DESC) AS RANK_AVG,         -- 고객의 랭킹
		fastcampus.orders.customer_id AS CUSTOMER_ID, 								   -- 고객 ID
		fastcampus.customers.customer_name AS CUSTOMER_NAME,						   -- 이름
		fastcampus.customers.gender AS CUSTOMER_GENDER,						           -- 성별
        fastcampus.customers.age AS CUSTOMER_AGE,                                      -- 나이
        fastcampus.customers.home_address AS CUSTOMER_HOME_ADDRESS,                    -- 주소
        count(fastcampus.orders.customer_id) AS COUNT_CUSTOMER, 					   -- 총 거래 횟수
		AVG(fastcampus.orders.payment) AS AVG_PAYMENT,								   -- 평균 구매금액
		SUM(fastcampus.orders.payment) AS SUM_PAYMENT								   -- 총 구매금액
        
FROM fastcampus.orders
INNER JOIN fastcampus.customers
ON fastcampus.orders.customer_id = fastcampus.customers.customer_id
WHERE fastcampus.orders.customer_id > 0
GROUP BY fastcampus.orders.customer_id,
		 fastcampus.customers.customer_name,
         fastcampus.customers.gender,
         fastcampus.customers.age,
         fastcampus.customers.home_address
LIMIT 200;
*/



-- KPI 지표 : 주문 날짜 - 배송 날짜를 이용한 배달 기간 추출 
-- 이를 이용한 거리에 대한 금액 비교
/*
SELECT RANK() OVER(ORDER BY AVG(fastcampus.orders.payment) DESC) AS RANK_AVG,          -- 구매 금액의 순위
       AVG(fastcampus.orders.payment) AS AVG_PAYMENT,								   -- 평균 구매금액
       SUM(fastcampus.orders.payment) AS SUM_PAYMENT,								   -- 총 구매금액
       DATEDIFF(delivery_date, order_date) AS DIFF_DAY								   -- 날짜의 차
FROM fastcampus.ORDERS
WHERE DATEDIFF(delivery_date, order_date) > 0
GROUP BY DATEDIFF(delivery_date, order_date)
*/
-- 이를 통해 배송이 4일 걸리는 지역에서 평균적으로 제일 많은 금액을 주문 하는 것을 확인 할 수 있으며, 
-- 19일이 걸리는 지역에서 평균적으로 가장 적은 금액을 주문 하는 것을 확인 할 수 있다.
