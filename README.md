# Supervisao-Inteligente
This is a final work about Inteligent Supervision.
Here are some commands you can use:

LabWork2:

- start_retrieve_place_cell_sequential_plan(3, 5.0).
- start_goto_xz_plan_delayed(5, 3.0).
- start_retrieve_place_right_sequential_plan(3, 5.0).

How to Run:
- SwiProlog: consult warehouse_supervisor.pl
- SwiProlog: start_server(8082).
- Visual Studio: Run project.
- SwiProlog: init.
- Open on web browser: http://localhost:8081/ss_multi_parts.html
- Open on web browser: http://localhost:8081/hmi/HMI.html

Features:
-> Ver as failures ativas
-> Ver as posições em cada eixo
-> Ver o numero total de failures e o numero de failures por resolver
-> Ver o numero pacotes em stock, que ja foram retirados e total na GUI
-> Emergency Stop e Resume Emergency

Bugs:
-> É guardado o número de pacotes em stock, que ja foram retirados e o total mal o plano é criado e não quando o plano é finalizado
