-- Challenge
-- Employee count by title
SELECT ti.title, COUNT(ti.title) as number_of_retirees
INTO number_retiring
FROM retirement_info as ri
INNER JOIN titles as ti
ON (ri.emp_no = ti.emp_no)
GROUP BY ti.title;

select * from number_retiring;
drop table number_retiring;

-- Number of current employees per title
SELECT ti.title, COUNT(e.emp_no) AS number_of_employees
INTO current_emp_by_title
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE ti.to_date='9999-01-01'
GROUP BY ti.title;

select * from current_emp_by_title;
drop table current_emp_by_title;

SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	s.salary
INTO retiring_by_title_info
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31');


select * from retiring_by_title_info;
drop table retiring_by_title_info;

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	ri.title,
	ri.from_date,
	ri.salary,
	de.to_date
INTO new_retiring_by_title_info
FROM retiring_by_title_info as ri
INNER JOIN dept_emp as de
ON (ri.emp_no = de.emp_no);

-- Partition the data to show only most recent title per employee
SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date,
	salary
INTO retiring_info_no_duplicates
FROM
 (SELECT emp_no,
		first_name,
		last_name,
		title,
		from_date,
		salary, ROW_NUMBER() OVER
 (PARTITION BY (emp_no) 
  ORDER BY to_date DESC) rn
 FROM new_retiring_by_title_info
 ) tmp WHERE rn = 1
ORDER BY emp_no;
select * from retiring_info_no_duplicates;

--Generating list eligible for mentorship
SELECT e.emp_no,
	e.first_name,
	e.last_name,
	ti.title,
	ti.from_date,
	de.to_date
INTO eligible_mentors
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31');

select * from eligible_mentors
SELECT emp_no,
	first_name,
	last_name,
	title,
	from_date,
	to_date
INTO eligible_mentors_no_duplicates
FROM
 (SELECT emp_no,
		first_name,
		last_name,
		title,
		from_date,
		to_date, ROW_NUMBER() OVER
 (PARTITION BY (emp_no) 
  ORDER BY to_date DESC) rn
 FROM eligible_mentors
 ) tmp WHERE rn = 1
ORDER BY emp_no;

select * from eligible_mentors_no_duplicates;