package biblioteca_mea;

`define nr_biti 32
`define size_matrice 5

typedef struct
{
    reg signed [`nr_biti-1:0] coord_x;
    reg signed [`nr_biti-1:0] coord_y;
}punct;

function reg signed [`nr_biti-1:0] mod(reg signed [`nr_biti-1:0] x, reg signed [`nr_biti-1:0] y);
    if(x%y<0)
        return x%y+y;
    return x%y;
endfunction

reg signed [`nr_biti-1:0] q=0;
function reg signed [`nr_biti-1:0] power(reg signed [`nr_biti-1:0] x, reg signed [`nr_biti-1:0] y, reg signed [`nr_biti-1:0] m);
    if (y == 0)
        return 1;
    q = mod(power(x,y/2,m),m);
    q=(q*q)%m;

    if (y%2==0)
        return q;
    return (x*q)%m;
endfunction
function reg signed [`nr_biti-1:0] modinv(reg signed [`nr_biti-1:0] x, reg signed [`nr_biti-1:0] y);
    return mod(power(x, y - 2, y), y);
endfunction

function punct adunare_punct(punct P, punct Q, reg signed [`nr_biti-1:0] m);
    punct R;
    reg signed [`nr_biti-1:0] aux=0;
    if (P.coord_x == Q.coord_x && P.coord_y == m - Q.coord_y)
        begin
            R.coord_x = 0;
            R.coord_y = 0;
            return R;
        end
    if (P.coord_x == 0 && P.coord_y == 0)
        begin
            R.coord_x = Q.coord_x;
            R.coord_y = Q.coord_y;
            return R;
        end
    if (Q.coord_x == 0 && Q.coord_y == 0)
        begin
            R.coord_x = P.coord_x;
            R.coord_y = P.coord_y;
            return R;
        end
    
    if (P.coord_x == Q.coord_x && P.coord_y == Q.coord_y)
        aux = mod((3 * P.coord_x * P.coord_x + 4) * modinv(2, m) * modinv(P.coord_y, m), m);
    else
        aux = mod((Q.coord_y - P.coord_y) * modinv(Q.coord_x - P.coord_x, m), m);
        
    R.coord_x = mod(-P.coord_x - Q.coord_x + aux * aux, m);
    R.coord_y = mod(-P.coord_y + aux * (P.coord_x - R.coord_x), m);
    
    return R;
endfunction

function punct inmultire_punct(reg signed [`nr_biti-1:0] k, punct P, reg signed [`nr_biti-1:0] m);
    
    punct R1;    
    punct matrice [5:0];
    reg signed [`nr_biti-1:0] i=0;
    reg signed [`nr_biti-1:0] auy=0;
    R1.coord_x=P.coord_x;
    R1.coord_y=P.coord_y;
    matrice[0]=R1;
    for(i=1;i<6;i++)
        begin
        R1=adunare_punct(R1,R1,m);
        matrice[i]=R1;
    end
    R1.coord_x=0;
    R1.coord_y=0;
    if(k==0)
    return R1;
    auy=k;
    for(i=5;i>=0;i--)
        begin
        if ((auy/(2**i))==1)
            begin
            R1=adunare_punct(R1,matrice[i],m);
            auy=auy%(2**i);
        end
    end
    return R1;
endfunction

endpackage
