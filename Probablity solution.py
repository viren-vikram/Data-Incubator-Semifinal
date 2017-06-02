import numpy as np
from random import random
from decimal import *
import sys
getcontext().prec=10
n =int(input('#toss:')) 
gp=int(input('#group>'))
excd=int(input('#gp>'))
h_exceed=int(input('#of head_count'))
h_gp_ex=int(input('#of group> last question:'))
p=.6
l=1000000
def flip(p):
	return 'H' if np.random.random()<=p else 'T'
def run():
	run =1
	head_cnt=0
	head_tail = [flip(p) for i in range(n)]
	for j in range(1,n):
		if 	head_tail[j-1]==head_tail[j]:
			run=run
		else:
			run += 1	
		if head_tail[j-1]=='H':
			head_cnt+=1
	return run, head_cnt
test_run =0.0
t_c=0.0
h_cnt=0.0
count_s,count_f =0.0,0.0	
for i in range(l):
	test_run,h_c= run()
	t_c +=test_run
	if test_run>gp:
		count_s+=1
	if test_run>excd:
		count_f+=1
	if test_run>h_gp_ex and h_c>h_exceed:
		h_cnt +=1
avg_r_f=t_c/l
avg_s_c=count_s/l
avg_f_c=count_f/l
exp_h_c= h_cnt/l
print Decimal(avg_r_f)   
print Decimal(avg_s_c)
print Decimal(avg_s_c/avg_f_c)
print Decimal(exp_h_c)