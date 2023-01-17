-- 1. 서비스 이용데이터(총 구매횟수, 총 구매금액, 평균 구매금액)에 대한 5등급 구분
-- 2. 1등급에 해당하는 고객의 랭킹(RANK() OVER (ORDER BY [컬럼 이름])) + 서비스 이용데이터(총 구매횟수, 총 구매금액, 평균 구매금액)
-- 3. 고객번호 : Customer_id가 KEY
-- 4. 열 : 1000 따라서 200개가 1등급에 해당

-- 1) 총 구매횟수

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



/* 
안녕하세요 리뷰어입니다. 다양한 지표를 기준으로 rank 해주셨고, 문제에서 요구하는 것을 모두 알맞게 출력해주셨습니다. sql 문법을 능숙하게 활용하시는 것으로 보입니다. 수고 많으셨습니다 :)
회원의 등급을 나누는 방법으로는 다양한 방법이 존재합니다. 무진님과 같이 분석가의 기준으로 값을 지정하여 나누어줄 수 있고(해당 분석을 계속 해오던 사람이라면, product의 kpi 혹은 마케팅 전략 등에 따라 값을 지정할 것입니다.), naive 하게는 총 구매 금액 기준 상위 20% 로 나누어줄 수도 있습니다. 
아래에 첨부드리는 코드는 naive 하게 상위 20%를 출력하는 코드이고 (schema만 맞춰주시면 실행 가능합니다), 이렇게 고객의 등급을 구분하는 다양한 방법이 존재하는 것을 알고 계시면 좋을 것입니다. 수고하셨습니다. 


select orders.ranking, customers.customer_id, customers.customer_name, customers.gender, customers.age, customers.home_address, customers.zip_code, customers.city, customers.state, orders.total_payment
from customers
join (
	select row_number() over (order by sub.total_payment desc) as ranking, sub.customer_id, sub.total_payment
	from ( 
			select customer_id, sum(payment) as total_payment
			from orders
			group by customer_id
			order by total_payment desc
            ) as sub
		) as orders
on customers.customer_id = orders.customer_id
where orders.ranking <= (select round(count(distinct(customer_id)) * 0.2) as total_customer from orders);

*/

-- KPI 지표 : 주문 날짜 - 배송 날짜를 이용한 배달 기간 추출 
-- 이를 이용한 거리에 대한 금액 비교

SELECT RANK() OVER(ORDER BY AVG(fastcampus.orders.payment) DESC) AS RANK_AVG,          -- 구매 금액의 순위
       AVG(fastcampus.orders.payment) AS AVG_PAYMENT,								   -- 평균 구매금액
       SUM(fastcampus.orders.payment) AS SUM_PAYMENT,								   -- 총 구매금액
       DATEDIFF(delivery_date, order_date) AS DIFF_DAY								   -- 날짜의 차
FROM fastcampus.ORDERS
WHERE DATEDIFF(delivery_date, order_date) > 0
GROUP BY DATEDIFF(delivery_date, order_date)

-- 이를 통해 배송이 4일 걸리는 지역에서 평균적으로 제일 많은 금액을 주문 하는 것을 확인 할 수 있으며, 
-- 19일이 걸리는 지역에서 평균적으로 가장 적은 금액을 주문 하는 것을 확인 할 수 있다.

/* 
해당 서비스 중에서도 특히 배송 기간에 대하여 KPI를 설정해주셨습니다. 적어주신 지표 외에도 '주문 후 배송 기간' 의 차이를 요일 별로 확인하여 큰 차이가 존재함을 확인한다면, 
해당 일자에 대한 배송 service에 대한 issue를 제기할 수 있을 것입니다. 배송 기간에 대한 kpi를 잘 설정해주셨고, 아래에 참조드리는 코드는 쇼핑몰의 전반적인 서비스 상황에 대한 kpi입니다. 
총 고객 수, 평균 교객 나이, 월별 평균 구매금액 등의 지표이며, 어떠한 서비스를 개선하고자 하는지에 따라 적절한 kpi를 설정하는 것이 매우 중요하다는 것을 알 수 있습니다.
수고 많으셨습니다 :)

select kpi.customer_count as "description", round(kpi.count) as "count"
from (
		select "customer_count", count(customer_id) as count from customers
		union select "avg_customer_age", avg(age) from customers
		union select "order_count", count(order_id) from orders
		union select "avg_delivery_date", avg(datediff(delivery_date, order_date)) from orders
		union select "avg_monthly_payment", avg(sub.payment)
			from (
					select sum(payment) as payment from orders group by date_format(order_date, "%Y-%m") 					
				)as sub
	) as kpi;

*/
