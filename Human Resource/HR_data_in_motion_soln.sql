-- Human Resources SQL Case Study --
----------------------------------------------------------------------------------------------------------------------------------------------------
-- 1] Find the longest ongoing project for each department.
-- SELECT p.name AS project_name, d.id AS dept_id, d.name AS dept_name, DATEDIFF(end_date, start_date) AS project_duration FROM projects p
-- JOIN departments d ON p.id = d.id
-- GROUP BY d.id 
-- ORDER BY project_duration DESC;
----------------------------------------------------------------------------------------------------------------------------------------------
-- 2] Find all employees who are not managers.
-- SELECT e.name AS emp_name, e.id, e.job_title FROM employees e
-- WHERE e.job_title NOT LIKE '%manager%';
----------------------------------------------------------------------------------------------------------------------------------------------
-- 3] Find all employees who have been hired after the start of a project in their department.
-- SELECT e.name AS emp_name, e.hire_date, p.start_date FROM employees e
-- JOIN projects p ON e.department_id = p.department_id  
-- WHERE e.hire_date > p.start_date;
----------------------------------------------------------------------------------------------------------------------------------------------
-- 4] Rank employees within each department based on their hire date (earliest hire gets the highest rank).
-- SELECT name AS emp_name, hire_date, department_id,
-- RANK() OVER(PARTITION BY department_id ORDER BY hire_date) AS rank_of_employee
-- FROM employees;
------------------------------------------------------------------------------------------------------------------------------------------------ 
-- 5] Find the duration between the hire date of each employee and the hire date of the next employee hired in the same department.
-- SELECT e1.name AS emp_name, e1.hire_date, e2.name AS emp_name, e2.hire_date, d.id AS dept_id, d.name AS dept_name, TIMESTAMPDIFF(year, e1.hire_date, e2.hire_date) AS duration_in_years FROM employees e1
-- JOIN employees e2 ON e1.department_id = e2.department_id
-- JOIN departments d ON e1.department_id = d.id AND e2.department_id = d.id
-- WHERE e2.hire_date > e1.hire_date
-- ORDER BY e1.department_id, e1.hire_date;
------------------------------------------------------------------------------------------------------------------------------------------------