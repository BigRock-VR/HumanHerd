using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpaceShip_Script : MonoBehaviour
{
    public GameObject _teleport;
    public GameObject _uiController;

    private float _counter;

    public Animator _ShipDeparture;
    //Lerp Variables

    private float _lerpCounter;
    public float _lerpMultiplier;
    // Start is called before the first frame update
    void Start()
    {
        _ShipDeparture = gameObject.GetComponent<Animator>();
    }

    void Update()
    {
        GameStarts();
        EndGame();
    }

    void GameStarts()
    {
        if (_counter < 10 && GameManager._gm._teleportSpawn)
        {
            _teleport.SetActive(true);
            Mathf.Clamp(_counter, 0f, 10f);
            _counter += Time.deltaTime;
            var f = _counter.Remap(0f, 10f, 0f, 0.4f);
            _teleport.GetComponent<MeshRenderer>().sharedMaterial.SetFloat("_Float0", f);
        }
    }

    void EndGame()
    {
        if (GameManager._gm._gameOver)
        {
            _teleport.SetActive(false);
            _lerpCounter += Time.deltaTime;
            if (_lerpCounter >= 2)
            {
                _uiController.GetComponent<UIController>()._gameOverUI.SetActive(false);
                _ShipDeparture.SetBool("StartAnimation", true);
                StartCoroutine(RestartGame());
            }
        }
    }

    IEnumerator RestartGame()
    {
        yield return new WaitForSeconds(10);
        _uiController.GetComponent<UIController>()._restartGameUI.SetActive(true);
    }
        
}
