//decides what attack Jade throws out based on the buttons pressed when she attacks
//it then assigns this data to the nextAttack variable
//list of atatcks and the variable they coresponds to
//0: not attacking
//1: jab
//2: grounded forward light
//3: grounded up light
//4: grounded down light
//5: nuetral air
//6: forward air
//7: up air
//8: back air
//9: down air

function AttackHandler(down_arrow, up_arrow, right_arrow, left_arrow, facing){
	var attack = 0
if(OBJ_Player.grounded){
	if(down_arrow){
		attack = 9
	}
	else if(up_arrow){
		attack = 7
	}
	else if(right_arrow){
		if(facing == 0){
			attack = 8
		}
		else{
			attack = 6	
		}
	}
	else if(left_arrow){
		if(facing == 0){
			attack = 6
		}
		else{
			attack = 8
		}
	}
	else{
		attack = 5	
	}
}
else{
	if(down_arrow){
		attack = 4
	}
	else if(up_arrow){
		attack = 3
	}
	else if(right_arrow || left_arrow){
		attack = 2
	}
	else{
		attack = 1
	}
}

OBJ_Player.nextAttack = attack
}