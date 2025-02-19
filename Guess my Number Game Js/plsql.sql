create table game(
    secret_number number,
    score number default 20,
    highscore number DEFAULT 0
);

create or replace procedure start_game
IS

begin 

delete from game;

insert into game (secret_number, score, highscore)
values (dbms_random.value(1, 20), 20, 0);

commit;

  dbms_output.put_line('Game started! Try guessing the number between 1 and 20.');
end start_game;


create or replace procedure guess_number(p_guess number)
IS

v_secret_number NUMBER;
v_score number;
v_highscore number;

BEGIN

    select secret_number, score, highscore 
    into v_secret_number, v_score, v_highscore
    from game;

    if p_guess = p_secret_number THEN
    DBMS_OUTPUT.PUT_LINE('🎉 Correct Number! You won!');

    IF v_score > v_highscore THEN
            UPDATE game SET highscore = v_score;
            COMMIT;
        END IF;

    elsif v_score > 1 THEN
    v_score := v_score - 1;
    update game set score = v_score;

    IF p_guess > v_secret_number THEN
            DBMS_OUTPUT.PUT_LINE('Too High! Try again.');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Too Low! Try again.');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Remaining Score: ' || v_score);
        COMMIT;

        ELSE
         DBMS_OUTPUT.PUT_LINE('💥 You Lost the Game! The correct number was ' || v_secret_number);

         UPDATE game_state SET secret_number = DBMS_RANDOM.VALUE(1, 20), score = 20;
        COMMIT;
    END IF;
END guess_number;
        

   
   
   
   CREATE OR REPLACE PROCEDURE check_highscore IS
    v_highscore NUMBER;
BEGIN
    SELECT highscore INTO v_highscore FROM game_state;
    DBMS_OUTPUT.PUT_LINE('Highscore: ' || v_highscore);
END check_highscore;     