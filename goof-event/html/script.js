window.onload = () => {
    const container = document.getElementById('container');
    container.style.display = 'none'; 
    const submitBtn = document.getElementById('submitBtn');
    const cancelBtn = document.getElementById('cancelBtn');
    const inputCoords = document.getElementById('inputCoords');

    submitBtn.addEventListener('click', () => {
        const coordsString = inputCoords.value.trim();
        const parts = coordsString.split(',');

        if(parts.length !== 3) {
            alert('Vul geldige coördinaten in met het formaat x,y,z');
            return;
        }

        const x = parseFloat(parts[0]);
        const y = parseFloat(parts[1]);
        const z = parseFloat(parts[2]);

        if (isNaN(x) || isNaN(y) || isNaN(z)) {
            alert('Vul geldige getallen in!');
            return;
        }

        
        fetch(`https://${GetParentResourceName()}/setCoords`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify({ x, y, z }),
        });

        // Sluit UI
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST'
        });
    });

    cancelBtn.addEventListener('click', () => {
        fetch(`https://${GetParentResourceName()}/closeUI`, {
            method: 'POST'
        });
    });

    window.addEventListener('message', (event) => {
        if (event.data.action === 'show') {
            container.style.display = 'block';
        }
        if (event.data.action === 'hide') {
            container.style.display = 'none';
        }
    });
};
