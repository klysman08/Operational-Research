

#Max: 350(mesa) + 470(cama) + 610(armario)

#s.a:

#mesa+cama <= 120

#armario <= 48

#10(mesa)+15(cama)+20(armario) <= 2000

var mesa, >= 0;
var cama, >= 0;
var armario, >= 0;


maximize LucroTotal: 320*mesa + 470*cama + 610*armario;
s.t. HorasMontagem_Limitada: mesa + cama <= 120;
s.t. HorasPintura_Limitada: armario <= 48;
s.t. HorasFuncionario_Limitada: 10*mesa + 15*cama + 20*armario = 2000;

solve;
display LucroTotal;

display mesa;