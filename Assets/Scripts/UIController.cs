using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class UIController : MonoBehaviour
{
    public Text _humanAvaible, _humanRescued, _sliderText, _timerText;
    public Slider _boostSpeedSlider;

    public GameObject _player, _gameUI, _gameOverUI, _gameStartUI, _overlay, _restartGameUI;
    private int counter;

    // Start is called before the first frame update
    void Start()
    {
        StartGame();
    }

    // Update is called once per frame
    void Update()
    {
        HumanCounter();
        SliderController();
        TimerController();
        GameOver();

        UIChange();
    }

    void SliderController()
    {
        if (_player != null)
        {
            _boostSpeedSlider.value = _player.GetComponent<PlayerController>()._counter;
            if (!_player.GetComponent<PlayerController>()._canRun)
            {
                _sliderText.text = "OverHeating";
                _sliderText.color = Color.red;
                _boostSpeedSlider.transform.GetChild(0).transform.GetChild(0).GetComponent<Image>().color = Color.red;
            }
            if (_player.GetComponent<PlayerController>()._canRun)
            {
                _sliderText.text = "Boost speed";
                _sliderText.color = Color.green;
                _boostSpeedSlider.transform.GetChild(0).transform.GetChild(0).GetComponent<Image>().color = Color.green;
            }
        }
    }

    void HumanCounter()
    {
        _humanAvaible.text = "Human Roaming: " + GameManager._gm._humanInScene;
        _humanRescued.text = "Human Rescued: " + GameManager._gm._humanPickedUp;
    }

    void TimerController()
    {
        if (Mathf.Floor(GameManager._gm._timer % 60) >= 10)
        {
            _timerText.text = Mathf.FloorToInt(GameManager._gm._timer / 60).ToString() + " : " + Mathf.Floor(GameManager._gm._timer % 60).ToString();
        }
        if (Mathf.Floor(GameManager._gm._timer % 60) < 10)
        {
            _timerText.text = Mathf.FloorToInt(GameManager._gm._timer / 60).ToString() + " : 0" + Mathf.Floor(GameManager._gm._timer % 60).ToString();
        }
    }

    void UIChange()
    {
        if (Input.GetKeyDown(GameManager._gm._startGame))
        {
            _gameStartUI.SetActive(false);
        }
        if (GameManager._gm._playerSpawned)
        {
            if (Time.timeScale == 0)
            {
                _overlay.SetActive(true);
            }
        }
        if (!GameManager._gm._playerSpawned)
        {
            _overlay.SetActive(false);
            
        }
        if (GameManager._gm._timerStarts)
        {
            _player = GameObject.FindGameObjectWithTag("Player");
            _gameUI.SetActive(true);
        }
    }

    void StartGame()
    {
        _gameStartUI.SetActive(true);
        _gameUI.SetActive(false);
        _gameOverUI.SetActive(false);
        _restartGameUI.SetActive(false);
    }

    void GameOver()
    {
        if (GameManager._gm._gameOver && counter == 0)
        {
            GameManager._gm._timerStarts = false;
            _gameUI.SetActive(false);
            _gameOverUI.SetActive(true);
            counter++;
        }
    }

        public void RestartGame()
    {
        SceneManager.LoadScene(0);
    }
}
