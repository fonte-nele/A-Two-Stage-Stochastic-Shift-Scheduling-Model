# Alocação de Pessoas.
param n , integer >=0;

#Conjuntos
set D:= {1..14}; 			/*Dias no periodo de 2 semanas*/
set S:= {1..3}; 			/*Turnos s1(dia),s2(noite),s3(madrugada)*/
set L:= {1..3}; 			/*Nível de funcionario l1(junior), l2(senior),l3(principal)*/
set P:= {1..n}; 			/*Horários que o analista poderia trabalhar */
set K:= {D,S};				/*Cenário, turno s no dia d*/

param rate{rl in L}; 							/*Número de alertas que um analista l pode atender durante um turno*/
param prob{(kd,ks) in K};						/*Probabilidade do cenario k no dia d no turno s*/
param alerts{(ak,akk) in K};					/*O número de alertas de entrada no dia d durante o turno s no cenário k*/
param spotcost{ss in S};						/*Custo para contratar analista senior para um turno s*/
param cost{cl in L} >= 0;						/*Custo do analista de nível l, na programação p */
param z{p in P, s in S, d in D }, binary; 		/*Toma o valor 1 se na programaçõo p inclui analista que está no  turno de trabalho  s no dia d,  e 0 caso contrário. */

#Variáveis de decisão
var X {xl in L, xp in P }, integer >=0;						/*Número de analistas de level l programação cenário p*/
var V {s in S, d in D, (vk,vkk) in K }, integer >=0;		/*v|s, d, k] =1 : Número de analistas seniores  que devem ser contratados para o turno s no dia d sobre o cenário k  */

#Função Objetivo
minimize obj: sum {l in L} (sum {p in P} (cost[l]*X[l,p])) + sum{d in D, s in S} (sum {(kd,ks) in K} prob[kd,ks] * spotcost[s] * V[s,d,kd,ks]);
/*Achar alocacao mais barata */

#restrições
s.t. rest1{s in S, d in D, (kd,ks) in K} : rate[2] * V[s,d,kd,ks] + sum{p in P} (sum {l in L} (z[p,s,d] * rate[l] * X[l,p])) >= alerts[kd,ks];

s.t. rest2{s in S, d in D}: sum{p in P}(z[p,s,d] * X[1,p]) <= (sum{p in P}(z[p,s,d]) * (3*X[2,p] + 6*X[3,p])); 

s.t. rest3{s in S, l in L}: sum{p in P}(sum{d in D}(z[p,1,d]*X[l,p])) = 0;

s.t. rest4{s in S, d in D}: sum{p in P}(z[p,s,d]*X[2,p]) <= 4 + sum{p in P}(5 * z[p,s,d] * X[3,p]);

s.t. rest5{p in P}: X[1,p] <= 0.25 * sum{l in L}(X[l,p]);

s.t. rest6{p in P}: X[2,p] <= 0.25 * sum{l in L}(X[l,p]);

s.t. rest7{p in P}: X[3,p] <= 0.2 * sum{l in L}(X[l,p]);

solve;

printf "Custo total: %4.2f\n\n", obj;

data;

param n := 16;

param rate :=
	1 40
	2 60
	3 80;

param prob :
			1	2	3:=
		1	0.6	0.4	0.7
		2	0.5	0.8	0.6
		3	0.4	0.7	0.4
		4	0.5	0.6	0.2
		5	0.5	0.8	0.6
		6	0.4	0.7	0.4
		7	0.5	0.6	0.2
		8	0.5	0.8	0.6
		9	0.4	0.9	0.4
		10	0.5	0.6	0.5
		11	0.5	0.8	0.6
		12	0.3	0.7	0.4
		13	0.9	0.6	0.2
		14	0.6	0.7	0.6;

param spotcost :=
	1 400
	2 500
	3 600;

param cost :=
	1 300
	2 400
	3 600;

param z :=
	[1,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	0	1	0	0	1	0	1	1	0	1	0	1	1	0
			2	1	0	0	1	0	1	0	0	1	0	1	0	0	1
			3	1	1	0	1	0	0	1	1	0	1	0	0	1	0
	[2,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	1	1	0	1	0	1	0	1	1	0	1	0	1	1
			2	0	1	0	0	1	1	1	0	0	0	1	1	1	0
			3	0	0	0	1	0	0	1	1	0	0	1	0	0	0
	[3,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	0	1	0	0	1	0	1	1	0	1	0	1	1	0
			2	1	0	0	1	0	1	0	0	1	0	1	0	0	1
			3	1	1	0	1	0	0	1	1	0	1	0	0	1	0
	[4,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	1	1	0	1	0	1	0	1	1	0	1	0	1	1
			2	0	1	0	0	1	1	1	0	0	0	1	1	1	0
			3	0	0	0	1	0	0	1	1	0	0	1	0	0	0
	[5,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	0	1	0	0	1	0	1	1	0	1	0	1	1	0
			2	1	0	0	1	0	1	0	0	1	0	1	0	0	1
			3	1	1	0	1	0	0	1	1	0	1	0	0	1	0
	[6,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	1	1	0	1	0	1	0	1	1	0	1	0	1	1
			2	0	1	0	0	1	1	1	0	0	0	1	1	1	0
			3	0	0	0	1	0	0	1	1	0	0	1	0	0	0
	[7,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	0	1	0	0	1	0	1	1	0	1	0	1	1	0
			2	1	0	0	1	0	1	0	0	1	0	1	0	0	1
			3	1	1	0	1	0	0	1	1	0	1	0	0	1	0
	[8,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	1	1	0	1	0	1	0	1	1	0	1	0	1	1
			2	0	1	0	0	1	1	1	0	0	0	1	1	1	0
			3	0	0	0	1	0	0	1	1	0	0	1	0	0	0
	[9,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	0	1	0	0	1	0	1	1	0	1	0	1	1	0
			2	1	0	0	1	0	1	0	0	1	0	1	0	0	1
			3	1	1	0	1	0	0	1	1	0	1	0	0	1	0
	[10,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	1	1	0	1	0	1	0	1	1	0	1	0	1	1
			2	0	1	0	0	1	1	1	0	0	0	1	1	1	0
			3	0	0	0	1	0	0	1	1	0	0	1	0	0	0
	[11,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	0	1	0	0	1	0	1	1	0	1	0	1	1	0
			2	1	0	0	1	0	1	0	0	1	0	1	0	0	1
			3	1	1	0	1	0	0	1	1	0	1	0	0	1	0
	[12,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	1	1	0	1	0	1	0	1	1	0	1	0	1	1
			2	0	1	0	0	1	1	1	0	0	0	1	1	1	0
			3	0	0	0	1	0	0	1	1	0	0	1	0	0	0
	[13,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	0	1	0	0	1	0	1	1	0	1	0	1	1	0
			2	1	0	0	1	0	1	0	0	1	0	1	0	0	1
			3	1	1	0	1	0	0	1	1	0	1	0	0	1	0
	[14,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	1	1	0	1	0	1	0	1	1	0	1	0	1	1
			2	0	1	0	0	1	1	1	0	0	0	1	1	1	0
			3	0	0	0	1	0	0	1	1	0	0	1	0	0	0
	[15,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	0	1	0	0	1	0	1	1	0	1	0	1	1	0
			2	1	0	0	1	0	1	0	0	1	0	1	0	0	1
			3	1	1	0	1	0	0	1	1	0	1	0	0	1	0
	[16,*,*]:	1	2	3	4	5	6	7	8	9	10	11	12	13	14:=
			1	1	1	0	1	0	1	0	1	1	0	1	0	1	1
			2	0	1	0	0	1	1	1	0	0	0	1	1	1	0
			3	0	0	0	1	0	0	1	1	0	0	1	0	0	0;

param alerts :
			1	2	3:=
		1	5	11	7
		2	6	10	9
		3	7	8	16
		4	5	11	7
		5	6	10	9
		6	7	8	16
		7	5	11	7
		8	6	10	9
		9	7	8	16
		10	5	11	7
		11	7	8	16
		12	5	11	7
		13	7	10	6
		14	9	8	10;

end;